//
//  AddCategoryViewModel.swift
//  Footprint
//
//  Created by sandy on 2022/11/16.
//

import Foundation
import Combine
import RealmSwift

class AddCategoryViewModel: BaseViewModel {
    private let realm: Realm
    @Published var isAvailableSave: Bool = false
    
    @Published var name: String = ""
    @Published var pinType: PinType = .pin0
    var pinList: [PinType] = [.pin0,.pin1,.pin2,.pin3,.pin4,.pin5,.pin6,.pin7,.pin8,.pin9]
    @Published var isKeyboardVisible = false

    
    override init(_ coordinator: AppCoordinator) {
        self.realm = try! Realm()
        super.init(coordinator)
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
    
    func onClickSave() {
        self.isKeyboardVisible = false
        if name.isEmpty {
            self.alert(.ok, description: "카테고리명을 적어주세요")
            return
        }
        var tag: Int = 0
        if let lastCategory = self.realm.objects(Category.self).last {
            tag = lastCategory.tag + 1
        }
        try! realm.write {
            realm.add(Category(tag: tag, name: self.name, pinType: pinType))
            self.stopProgress()
            self.dismiss(animated: true)
        }
    }
}
