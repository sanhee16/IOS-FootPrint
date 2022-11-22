//
//  AddFootprintViewModel.swift
//  Footprint
//
//  Created by Studio-SJ on 2022/11/04.
//

import Foundation
import Combine
import UIKit
import RealmSwift

class AddFootprintViewModel: BaseViewModel {
    @Published var title: String = ""
    @Published var content: String = ""
    @Published var images: [UIImage] = []
    @Published var pinType: PinType = .pin0
    @Published var category: Category = Category(tag: -1, name: "선택안함", pinType: .pin0)
    @Published var isKeyboardVisible = false
    @Published var isCategoryEditMode: Bool = false

    var pinList: [PinType] = [.pin0,.pin1,.pin2,.pin3,.pin4,.pin5,.pin6,.pin7,.pin8,.pin9]
    var categories: [Category] = []
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
        print("sandy loadCategories")
        // 객체 초기화
        self.categories = []
        self.category = Category(tag: -1, name: "선택안함", pinType: .pin0)
        
        // let data = realm.objects(MyLocation.self).sorted(byKeyPath: "idx", ascending: true)

        // 모든 객체 얻기
        let dbCategories = realm.objects(Category.self).sorted(byKeyPath: "tag", ascending: true)
        self.categories.append(self.category)
        for i in dbCategories {
            self.categories.append(Category(tag: i.tag, name: i.name, pinType: i.pinType.pinType()))
        }
        print("done")
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
        self.coordinator?.presentGalleryView(onClickItem: { [weak self] (item: GalleryItem) in
            guard let self = self else { return }
            if !self.images.contains(item.image) {
                self.images.append(item.image)
            }
        })
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
            print("savedUrl : \(url)")
//            if let url = url {
//                print("savedUrl : \(url)")
//                imageUrls.append(url)
//            }
            imageUrls.append(imageName)
        }
        
        try! realm.write {
            let copy = FootPrint(title: self.title, content: self.content, images: imageUrls, latitude: self.location.latitude, longitude: self.location.longitude, pinType: self.pinType, tag: self.category.tag)
            realm.add(copy)
            self.stopProgress()
            self.dismiss(animated: true)
        }
    }

    func onSelectPin(_ item: PinType) {
        if self.category.tag != -1 {
            self.alert(.ok, title: "카테고리의 핀으로 설정되어서 변경할 수 없습니다.", description: "핀 변경을 원하시면 카테고리 선택을 해제하세요.")
            return
        }
        self.isKeyboardVisible = false
        self.pinType = item
    }
    
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
        if self.category.tag != -1, let pinType = PinType(rawValue: self.category.pinType) {
            self.pinType = pinType
        }
    }
    
    func editCategory(_ item: Category) {
        self.coordinator?.presentAddCategoryView(type: AddCategoryType(type: .update, category: item), onDismiss: {[weak self] in
            print("edit dismiss")
            self?.loadCategories()
        })
    }
    
    func deleteCategory(_ item: Category) {
        self.alert(.yesOrNo, title: "카테고리를 삭제하시겠습니까?", description: "카테고리를 삭제하면 기존 저장된 노트들은 사라집니다.") {[weak self] isDelete in
            guard let self = self else { return }
            if isDelete {
                if let filteredData = self.realm.object(ofType: Category.self, forPrimaryKey: item.tag) {
                    try! self.realm.write {
                        self.realm.delete(filteredData)
                        self.loadCategories()
                    }
                }
            } else {

            }
        }
    }
}
