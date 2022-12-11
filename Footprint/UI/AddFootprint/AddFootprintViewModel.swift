//
//  AddFootprintViewModel.swift
//  Footprint
//
//  Created by Studio-SJ on 2022/11/04.
//

import Foundation
import Combine
import UIKit
import Photos
import RealmSwift

public enum AddFootprintType {
    case new
    case modify(content: FootprintContents)
}

public struct FootprintContents {
    var title: String
    var content: String
    var images: [UIImage]
    var category: Category
    var peopleWith: [PeopleWith]
    var id: ObjectId
}


class AddFootprintViewModel: BaseViewModel {
    @Published var title: String = ""
    @Published var content: String = ""
    @Published var images: [UIImage] = []
    @Published var category: Category? = nil
    @Published var isKeyboardVisible = false
    @Published var isCategoryEditMode: Bool = false
    @Published var isPeopleWithEditMode: Bool = false
    
//    @Published var pinType: PinType = .star
//    @Published var pinColor: PinColor = .pin2
//    let pinList: [PinType] = [
//        .star,.restaurant,.coffee,.bread,.cake,.wine,.exercise,.heart,
//        .multiply,.like,.unlike,.done,.exclamation,.happy,.square
//    ]
//    let pinColorList: [PinColor] = [.pin0,.pin1,.pin2,.pin3,.pin4,.pin5,.pin6,.pin7,.pin8,.pin9]
    
    @Published var categories: [Category] = []
    @Published var peopleWith: [PeopleWith] = []
    
//    private var peopleWithIds: [Int] = []
    private var modifyId: ObjectId? = nil
    private let type: AddFootprintType
    private let location: Location
    private let realm: Realm
    
    init(_ coordinator: AppCoordinator, location: Location, type: AddFootprintType) {
        self.realm = try! Realm()
        self.location = location
        self.type = type
        
        self.categories = []
        self.category = realm.object(ofType: Category.self, forPrimaryKey: 0) // 시작할 때 기본 카테고리로 설정하기!
        
        super.init(coordinator)
        
        if case let .modify(contents) = self.type {
            self.title = contents.title
            self.content = contents.content
            self.images = contents.images
            self.category = contents.category
            self.peopleWith = contents.peopleWith
            self.modifyId = contents.id
        }
        
        print("sandy init")
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
        self.alert(.yesOrNo, title: nil, description: "저장하지 않고 나가시겠습니까?") {[weak self] isClose in
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
                self.coordinator?.presentGalleryView(onClickItem: { [weak self] (items: [GalleryItem]) in
                    guard let self = self else { return }
                    for item in items {
                        if !self.images.contains(item.image) {
                            self.images.append(item.image)
                        }
                    }
                })
            } else {
                self.alert(.ok, title: nil, description: "사진권한을 허용해야 사용할 수 있습니다.")
            }
        }
    }
    
    func removeImage(_ item: UIImage) {
        self.isKeyboardVisible = false
        self.alert(.yesOrNo, title: nil, description: "삭제하시겠습니까?") {[weak self] allowRemove in
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
    
    func onClickSave() {
        self.isKeyboardVisible = false
        guard let category = self.category else {
            self.alert(.ok, description: "카테고리를 골라주세요")
            return
        }

        if self.title.isEmpty {
            self.alert(.ok, description: "title을 적어주세요")
            return
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
        var peopleWithIds: List<Int> = List<Int>()
        peopleWithIds.append(objectsIn: self.peopleWith.map { selected in
            selected.id
        })
        
        try! realm.write {
//            let item = FootPrint(title: self.title, content: self.content, images: imageUrls, latitude: self.location.latitude, longitude: self.location.longitude, tag: category.tag)
            switch self.type {
            case .new:
                let item = FootPrint(title: self.title, content: self.content, images: imageUrls, latitude: self.location.latitude, longitude: self.location.longitude, tag: category.tag, peopleWithIds: peopleWithIds)
                realm.add(item)
            case .modify(content: _):
                if let id = self.modifyId, let item = self.realm.object(ofType: FootPrint.self, forPrimaryKey: id), let categoryTag = self.category?.tag {
                    item.title = self.title
                    item.tag = categoryTag
                    item.content = self.content
                    item.images = imageUrls
                    item.peopleWithIds = peopleWithIds
                    self.realm.add(item, update: .modified)
                }
            }
            self.stopProgress()
            self.dismiss(animated: true)
        }
    }
    
//    func onSelectPin(_ item: PinType) {
//        if self.category.tag != -1 {
//            self.alert(.ok, title: "카테고리의 핀으로 설정되어서 변경할 수 없습니다.", description: "핀 변경을 원하시면 카테고리 선택을 해제하세요.")
//            return
//        }
//        self.isKeyboardVisible = false
//        self.pinType = item
//    }
    
    func onClickAddCategory() {
        self.coordinator?.presentAddCategoryView(type: AddCategoryType(type: .create, category: nil), onDismiss: {[weak self] in
            self?.loadCategories()
        })
    }
    
    func onClickEditCategory() {
        self.isCategoryEditMode = !self.isCategoryEditMode
    }
    
    func onSelectCategory(_ item: Category) {
        self.category = item
    }
    
    func editCategory(_ item: Category) {
        if item.tag == 0 {
            self.alert(.ok, title: "기본 카테고리는 편집할 수 없습니다.")
            return
        }
        self.coordinator?.presentAddCategoryView(type: AddCategoryType(type: .update, category: item), onEraseCategory: {[weak self] in
            if item.tag == self?.category?.tag {
                self?.category = nil
                self?.dismiss(animated: true)
            }
        }, onDismiss: { [weak self] in
            self?.loadCategories()
        })
    }
    
    func onClickAddPeopleWith() {
        self.coordinator?.presentPeopleWithSelectorView(callback: {[weak self] res in
            self?.peopleWith = res
        })
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
