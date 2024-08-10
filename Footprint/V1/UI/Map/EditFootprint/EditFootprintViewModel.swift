//
//  EditFootprintViewModel.swift
//  Footprint
//
//  Created by Studio-SJ on 2022/11/04.
//

import Foundation
import Combine
import UIKit
import Photos
import RealmSwift

public enum EditFootprintType {
    case new(name: String?, placeId: String?, address: String?)
    case modify(content: FootprintContents)
}

public struct FootprintContents {
    var title: String
    var content: String
    var createdAt: Date
    var images: [UIImage]
    var category: Category
    var peopleWith: [PeopleWith]
    var id: ObjectId
    var isStar: Bool
}


class EditFootprintViewModel: BaseViewModelV1 {
    @Published var isStar: Bool = false
    @Published var title: String = ""
    @Published var content: String = ""
    @Published var images: [UIImage] = []
    @Published var category: Category
    @Published var isKeyboardVisible = false
    @Published var isCategoryEditMode: Bool = false
    @Published var isPeopleWithEditMode: Bool = false
    @Published var createdAt: Date = Date()
    
//    @Published var pinType: PinType = .star
//    @Published var pinColor: PinColor = .pin2
//    let pinList: [PinType] = [
//        .star,.restaurant,.coffee,.bread,.cake,.wine,.exercise,.heart,
//        .multiply,.like,.unlike,.done,.exclamation,.happy,.square
//    ]
//    let pinColorList: [PinColor] = [.pin0,.pin1,.pin2,.pin3,.pin4,.pin5,.pin6,.pin7,.pin8,.pin9]
    
    @Published var categories: [Category] = []
    @Published var peopleWith: [PeopleWith] = []
    @Published var type: EditFootprintType
    
//    private var peopleWithIds: [Int] = []
    private var modifyId: ObjectId? = nil
    private let location: Location
    private let realm: Realm
    private var placeId: String? = nil
    private var address: String? = nil
    
    init(_ coordinator: AppCoordinatorV1, location: Location, type: EditFootprintType) {
        self.realm = R.realm
        self.location = location
        self.type = type
        
        self.categories = []
        self.category = realm.object(ofType: Category.self, forPrimaryKey: 0)! // 시작할 때 기본 카테고리로 설정하기!
        
        super.init(coordinator)
        
        if case let .modify(contents) = self.type {
            self.createdAt = contents.createdAt
            self.title = contents.title
            self.content = contents.content
            self.images = contents.images
            self.category = contents.category
            self.peopleWith = contents.peopleWith
            self.modifyId = contents.id
            self.isStar = contents.isStar
        } else if case let .new(name, placeId, address) = self.type {
            self.title = name ?? ""
            self.placeId = placeId
            self.address = address
            let item = self.realm.object(ofType: PeopleWith.self, forPrimaryKey: 0)
            if let item = item {
                self.peopleWith.append(item)
            }
        } else {
            let item = self.realm.object(ofType: PeopleWith.self, forPrimaryKey: 0)
            if let item = item {
                self.peopleWith.append(item)
            }
        }
        
        self.loadCategories()
    }
    
    
    private func loadCategories() {
        self.categories = []
//        self.category = nil
        //TODO: self.category 되어있는거 삭제되었을 때 문제되니까 nil로 했는데 이거 수정필요함 => beforeCategory 만들어두긴했는데 코드 안ㅅ짬 이거 사용하던지 다른방식 사용하던지 해야함. loadCategories()에 파라미터 넣어가지고 콜백으로 지금 있는거 지워져쓴지 안지워졌는지 체크해야할 듯(beforeCategory 사용하지 않고)
        
        
        // 모든 객체 얻기
        let dbCategories = realm.objects(Category.self).sorted(byKeyPath: "tag", ascending: true)
        for i in dbCategories {
            //MARK: 이슈 해결: realm 에 data를 넣을 때에는 copy(얕은 복사)를 해서 넣어야만 삭제시 삭제된 아이템 주소 참조가 안되어서 크래시발생 안함.
            // 삭제했는데 같은 주소를 참조하기 때문에 계속 크래시 발생하기 때문
            self.categories.append(Category(tag: i.tag, name: i.name, pinType: i.pinType.pinType(), pinColor: i.pinColor.pinColor()))
        }
        
    }
    
    
    func onAppear() {
        
    }
    
    func onClose() {
        self.isKeyboardVisible = false
        self.alert(.yesOrNo, title: nil, description: "alert_out_without_save".localized()) {[weak self] isClose in
            guard let self = self else { return }
            if isClose {
                self.dismiss()
            }
        }
    }
    
    func onClickGallery() {
        self.isKeyboardVisible = false
        self.photoPermissionCheck {[weak self] isAllow in
            guard let self = self else { return }
            if isAllow {
                self.coordinator?.presentGalleryView(type: .multi, onClickItem: { [weak self] (items: [GalleryItem]) in
                    guard let self = self else { return }
                    for item in items {
                        if !self.images.contains(item.image) {
                            self.images.append(item.image)
                        }
                    }
                })
            } else {
                self.alert(.ok, title: nil, description: "alert_permission_album".localized())
            }
        }
    }
    
    func removeImage(_ item: UIImage) {
        self.isKeyboardVisible = false
        self.alert(.yesOrNo, title: nil, description: "alert_delete".localized()) {[weak self] allowRemove in
            guard let self = self else { return }
            if allowRemove {
                for idx in self.images.indices {
                    if self.images[idx] == item {
                        self.images.remove(at: idx)
                        break
                    }
                }
            }
        }
    }
    
    func onClickDelete(_ id: ObjectId) {
        self.alert(.yesOrNo, title: "alert_delete".localized(), description: "alert_delete_item".localized("\(Defaults.deleteDays)")) {[weak self] isDelete in
            guard let self = self else { return }
            if isDelete {
                guard let item = self.realm.object(ofType: FootPrint.self, forPrimaryKey: id) else {
                    self.alert(.ok, title: "alert_fail".localized())
                    return
                }
                try! self.realm.write {[weak self] in
                    guard let self = self else { return }
                    item.deleteTime = Int(Date().timeIntervalSince1970)
                    self.realm.add(item, update: .modified)
                    self.stopProgress()
                    self.dismiss()
                }
            } else {
                return
            }
        }
    }
    
    func onClickSave() {
        self.isKeyboardVisible = false
        if self.title.isEmpty, self.content.isEmpty {
            self.dismiss()
            return
        }
        if self.title.isEmpty {
            self.title = "no_title".localized();
        }
        // image save
        self.startProgress()
        let imageUrls: List<String> = List<String>()
        let currentTimeStamp = Int(Date().timeIntervalSince1970)
        for idx in self.images.indices {
            let imageName = "\(currentTimeStamp)_\(idx)"
            let _ = ImageManager.shared.saveImage(image: self.images[idx], imageName: imageName)
            imageUrls.append(imageName)
        }
        print("imageUrls: \(imageUrls)")
        //TODO: modify 안되고 add 되는데 primaryKey issue일 것 = update: .modified 글로벌 서치해서 addCategoryViewModel 참고하기
        let peopleWithIds: List<Int> = List<Int>()
        peopleWithIds.append(objectsIn: self.peopleWith.map { selected in
            selected.id
        })
        print("peopleWithIds: \(peopleWithIds)")
        
        try! realm.write {[weak self] in
            guard let self = self else { return }
            switch self.type {
            case .new:
                print("new")
                let item = FootPrint(title: self.title, content: self.content, images: imageUrls, createdAt: self.createdAt, latitude: self.location.latitude, longitude: self.location.longitude, tag: category.tag, peopleWithIds: peopleWithIds, placeId: self.placeId, address: self.address, isStar: self.isStar)
                realm.add(item)
            case .modify(content: _):
                print("modify")
                if let id = self.modifyId, let item = self.realm.object(ofType: FootPrint.self, forPrimaryKey: id) {
                    item.title = self.title
                    item.tag = self.category.tag
                    item.content = self.content
                    item.createdAt = Int(self.createdAt.timeIntervalSince1970)
                    item.images = imageUrls
                    item.peopleWithIds = peopleWithIds
                    item.isStar = self.isStar
                    self.realm.add(item, update: .modified)
                }
            }
            self.stopProgress()
            self.dismiss()
        }
    }
    
    func onClickSelectCategory() {
        self.coordinator?.presentCategorySelectorView(type: .select(selectedCategory: self.category, callback: { [weak self] category in
            self?.category = category
        }))
    }
    
    func onClickAddPeopleWith() {
        var list: [PeopleWith] = self.peopleWith
        if let idx = self.peopleWith.firstIndex(where: { item in
            item.id == 0
        }) {
            list.remove(at: idx)
        }
        self.coordinator?.presentPeopleWithSelectorView(type: .select(peopleWith: list, callback: {[weak self] res in
            guard let self = self else { return }
            self.peopleWith.removeAll()
            if res.isEmpty {
                let item = self.realm.object(ofType: PeopleWith.self, forPrimaryKey: 0)
                if let item = item {
                    self.peopleWith.append(item)
                }
            } else {
                self.peopleWith = res
            }
        }))
    }
    
    private func photoPermissionCheck(_ callback: @escaping (Bool)->()) {
        let photoAuthStatus = PHPhotoLibrary.authorizationStatus()
        switch photoAuthStatus {
        case .notDetermined:
            print("권한 승인을 아직 하지 않음")
            PHPhotoLibrary.requestAuthorization() { status in
                switch status {
                case .denied:
                    print("거부됨")
                    callback(false)
                    break
                case .authorized:
                    print("승인됨")
                    callback(true)
                    break
                default:
                    callback(false)
                    break
                }
            }
        case .restricted:
            print("권한을 부여할 수 없음")
            callback(false)
            break
        case .denied:
            print("거부됨")
            callback(false)
            break
        case .authorized:
            print("승인됨")
            callback(true)
            break
        case .limited:
            print("limited")
            callback(false)
            break
        @unknown default:
            print("unknown default")
            callback(false)
            break
        }
    }
}
