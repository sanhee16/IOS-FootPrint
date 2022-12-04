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

class AddFootprintViewModel: BaseViewModel {
    @Published var title: String = ""
    @Published var content: String = ""
    @Published var images: [UIImage] = []
    @Published var category: Category? = nil
    @Published var isKeyboardVisible = false
    @Published var isCategoryEditMode: Bool = false
    
//    @Published var pinType: PinType = .star
//    @Published var pinColor: PinColor = .pin2
//    let pinList: [PinType] = [
//        .star,.restaurant,.coffee,.bread,.cake,.wine,.exercise,.heart,
//        .multiply,.like,.unlike,.done,.exclamation,.happy,.square
//    ]
//    let pinColorList: [PinColor] = [.pin0,.pin1,.pin2,.pin3,.pin4,.pin5,.pin6,.pin7,.pin8,.pin9]
    
    @Published var categories: [Category] = []
    private let location: Location
    private let realm: Realm
    
    init(_ coordinator: AppCoordinator, location: Location) {
        self.realm = try! Realm()
        self.location = location
        super.init(coordinator)
        
        print("sandy init")
        self.loadCategories()
    }
    
    
    private func loadCategories() {
        // 객체 초기화
        self.categories = []
        self.category = nil
        
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
        guard let category = category else {
            self.alert(.ok, description: "카테고리를 골라주세요")
            return
        }

        if self.title.isEmpty {
            self.alert(.ok, description: "title을 적어주세요")
            return
        } else if self.content.isEmpty {
            self.alert(.ok, description: "내용을 적어주세요")
            return
        }
        // image save
        self.startProgress()
        let imageUrls: List<String> = List<String>()
        let currentTimeStamp = Int(Date().timeIntervalSince1970)
        for idx in self.images.indices {
            let imageName = "\(currentTimeStamp)_\(idx)"
            let url = ImageManager.shared.saveImage(image: self.images[idx], imageName: imageName)
            //            print("savedUrl : \(url)")
            //            if let url = url {
            //                print("savedUrl : \(url)")
            //                imageUrls.append(url)
            //            }
            imageUrls.append(imageName)
        }
        
        try! realm.write {
            let copy = FootPrint(title: self.title, content: self.content, images: imageUrls, latitude: self.location.latitude, longitude: self.location.longitude, tag: category.tag)
            realm.add(copy)
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
        self.coordinator?.presentAddCategoryView(type: AddCategoryType(type: .update, category: item), onDismiss: {[weak self] in
            print("edit dismiss")
            self?.loadCategories()
        })
    }
    
//    func deleteCategory(_ item: Category) {
//        self.alert(.yesOrNo, title: "카테고리를 삭제하시겠습니까?", description: "카테고리를 삭제하면 기존 저장된 노트들은 사라집니다.") {[weak self] isDelete in
//            guard let self = self else { return }
//            if isDelete {
//                if let filteredData = self.realm.object(ofType: Category.self, forPrimaryKey: item.tag) {
//                    try! self.realm.write {
//                        self.realm.delete(filteredData)
//                        self.loadCategories()
//                    }
//                }
//            } else {
//
//            }
//        }
//    }
    
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
