//
//  AddCategoryViewModel.swift
//  Footprint
//
//  Created by sandy on 2022/11/16.
//

import Foundation
import Combine
import RealmSwift


struct AddCategoryType {
    enum AddType: Equatable {
        case create
        case update
    }
    var type: AddType
    var category: Category?
}

class AddCategoryViewModel: BaseViewModel {
    private let realm: Realm
    @Published var isAvailableSave: Bool
    
    @Published var name: String = ""
    @Published var pinType: PinType = .star
    @Published var pinColor: PinColor = .pin2
    let pinList: [PinType] = [
        .star,.restaurant,.coffee,.bread,.cake,.wine,.exercise,.heart,
        .multiply,.like,.unlike,.done,.exclamation,.happy,.square
    ]
    let pinColorList: [PinColor] = [.pin0,.pin1,.pin2,.pin3,.pin4,.pin5,.pin6,.pin7,.pin8,.pin9]
    @Published var isKeyboardVisible = false
    @Published var type: AddCategoryType
    private var onEraseCategory: (()->())?
    
    init(_ coordinator: AppCoordinator, type: AddCategoryType, onEraseCategory: (()->())?) {
        self.type = type
        self.realm = try! Realm()
        self.isAvailableSave = type.type == .update
        self.onEraseCategory = onEraseCategory
        super.init(coordinator)
        if self.type.type == .update, let item = self.type.category {
            self.name = item.name
            self.pinType = PinType(rawValue: item.pinType) ?? .star
            self.pinColor = PinColor(rawValue: item.pinColor) ?? .pin2
        }
    }
    
    func onAppear() {
        
    }
    
    func onClose() {
        self.isKeyboardVisible = false
        self.dismiss()
    }
    
    func onSelectPin(_ item: PinType) {
        self.isKeyboardVisible = false
        self.pinType = item
    }
    
    func onSelectPinColor(_ item: PinColor) {
        self.isKeyboardVisible = false
        self.pinColor = item
    }
    
    func onClickSave() {
        self.isKeyboardVisible = false
        if name.isEmpty {
            self.alert(.ok, description: "카테고리명을 적어주세요")
            return
        }
        switch self.type.type {
        case .update:
            self.startProgress()
            print("update")
            
            if let category = self.type.category, let filteredData = self.realm.object(ofType: Category.self, forPrimaryKey: category.tag) {
                try! self.realm.write {
                    let item = Category(tag: filteredData.tag, name: self.name, pinType: self.pinType, pinColor: self.pinColor)
                    
                    self.realm.add(item, update: .modified)
                    self.stopProgress()
                    self.dismiss(animated: true)
                }
            }
        case .create:
            self.startProgress()
            print("create")
            var tag: Int = 0
            if let lastCategory = self.realm.objects(Category.self).last {
                tag = lastCategory.tag + 1
            }
            try! realm.write {
                let copy = Category(tag: tag, name: self.name, pinType: pinType, pinColor: self.pinColor)
                var showingCategories = Defaults.showingCategories
                showingCategories.append(tag)
                Defaults.showingCategories = showingCategories
                realm.add(copy)
                self.stopProgress()
                self.dismiss(animated: true)
            }
        }
    }
    
    func onClickDelete() {
        if let category = self.type.category, let filteredData = self.realm.object(ofType: Category.self, forPrimaryKey: category.tag) {
            
            self.alert(.yesOrNo, title: "카테고리를 삭제하시겠습니까?", description: "카테고리를 삭제하면 기존 저장된 노트들은 사라집니다.") {[weak self] isDelete in
                guard let self = self else { return }
                print("delete")
                if isDelete {
                    try! self.realm.write {
                        let copy = filteredData
                        self.type.category = nil
                        self.realm.delete(copy)
                        self.dismiss(animated: true) { [weak self] in
                            self?.onEraseCategory?()
                        }
                    }
                }
            }
        } else {
            self.alert(.ok, title: "오류가 발생했습니다.", description: "잠시 후 다시 시도해 주세요.")
        }
    }
}
