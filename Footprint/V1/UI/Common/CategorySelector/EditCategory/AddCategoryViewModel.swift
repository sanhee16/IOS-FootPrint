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

class AddCategoryViewModel: BaseViewModelV1 {
    private let realm: Realm
    @Published var isAvailableSave: Bool
    
    @Published var name: String = ""
    @Published var pinType: PinType = .star
    @Published var pinColor: PinColor = .pin0
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
        self.realm = R.realm
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
            self.alert(.ok, description: "alert_enter_category_name".localized())
            return
        }
        switch self.type.type {
        case .update:
            self.startProgress()
            print("update")
            
            if let category = self.type.category, let filteredData = self.realm.object(ofType: Category.self, forPrimaryKey: category.tag) {
                try! self.realm.write {[weak self] in
                    guard let self = self else { return }
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
            try! realm.write {[weak self] in
                guard let self = self else { return }
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
            if category.tag == 0 {
                self.alert(.ok, title: "alert_cannot_delete_basic_category".localized())
                return
            }
            
            self.alert(.yesOrNo, title: "alert_delete_category".localized(), description: "alert_detete_category_description".localized()) {[weak self] isDelete in
                guard let self = self else { return }
                let items = self.realm.objects(FootPrint.self)
                    .filter { footPrint in
                        footPrint.tag == category.tag
                    }
                if isDelete {
                    try! self.realm.write {[weak self] in
                        guard let self = self else { return }
                        for i in items {
                            self.realm.delete(i)
                        }
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
            self.alert(.ok, title: "alert_error".localized(), description: "alert_error_try_again".localized())
        }
    }
}
