//
//  PeopleEditViewModel.swift
//  Footprint
//
//  Created by Studio-SJ on 2022/12/16.
//

import Foundation
import Combine
import UIKit
import RealmSwift

public enum PeopleEditType: Equatable {
    case new
    case modify
}

public struct PeopleEditStruct {
    let type: PeopleEditType
    let item: PeopleWith
    
    init(_ type: PeopleEditType, item: PeopleWith) {
        self.type = type
        self.item = item
    }
    
    init(_ type: PeopleEditType, name: String) {
        self.type = type
        self.item = PeopleWith(id: 0, name: name, image: "", intro: "")
    }
}

class PeopleEditViewModel: BaseViewModel {
    let peopleEditStruct: PeopleEditStruct
    let type: PeopleEditType
    @Published var name: String = ""
    @Published var image: UIImage? = nil
    @Published var intro: String = ""
    var isChange: Bool = false
    private var id: Int? = nil
    private let realm: Realm
    var isChangeImage: Bool = false
    private let callback: ((Int?) -> ())
    
    init(_ coordinator: AppCoordinator, peopleEditStruct: PeopleEditStruct, callback: @escaping ((Int?) -> ())) {
        self.peopleEditStruct = peopleEditStruct
        self.type = peopleEditStruct.type
        self.realm = try! Realm()
        self.callback = callback
        super.init(coordinator)
        
        switch self.type {
        case .new:
            self.name = self.peopleEditStruct.item.name
            self.image = nil
            self.intro = ""
            self.id = nil
        case .modify:
            self.name = self.peopleEditStruct.item.name
            self.image = ImageManager.shared.getSavedImage(named: self.peopleEditStruct.item.image)
            self.intro = self.peopleEditStruct.item.intro
            self.id = self.peopleEditStruct.item.id
        }
    }
    
    func onAppear() {
        
    }
    
    func onClose() {
        if !isChange {
            self.dismiss()
            return
        }
        self.alert(.yesOrNo, title: "alert_out_without_save".localized()) {[weak self] res in
            guard let self = self else { return }
            if res {
                self.dismiss()
            } else {
                return
            }
        }
    }
    
    func deleteItem() {
        if type == .new {
            return
        }
        self.alert(.yesOrNo, title: "alert_delete".localized(), description: "alert_delete_people_with_description".localized()) {[weak self] res in
            guard let self = self else { return }
            if !res {
                return
            }
            try! self.realm.write {[weak self] in
                guard let self = self else { return }
                self.startProgress()
                let deleteItem = self.peopleEditStruct.item
                let deleteId = deleteItem.id
                self.realm.delete(deleteItem)
                self.stopProgress()
                self.dismiss { [weak self] in
                    self?.callback(deleteId)
                }
            }
        }
    }
    
    func addItem() {
        if type == .modify {
            return
        }
        var id: Int = 0
        if self.realm.objects(PeopleWith.self).isEmpty {
            id = 0
        } else if let lastItem = self.realm.objects(PeopleWith.self).last {
            id = lastItem.id + 1
        } else {
            return
        }
        try! self.realm.write {[weak self] in
            guard let self = self else { return }
            self.startProgress()
            var imageName: String = ""
            if let image = self.image {
                let currentTimeStamp = Int(Date().timeIntervalSince1970)
                imageName = "\(currentTimeStamp)_people_with"
                _ = ImageManager.shared.saveImage(image: image, imageName: imageName)
            }
            let addItem = PeopleWith(id: id, name: self.name, image: imageName, intro: self.intro)
            self.realm.add(addItem)
            self.stopProgress()
            self.dismiss { [weak self] in
                self?.callback(nil)
            }
        }
    }
    
    func saveItem() {
        if type == .new {
            return
        }
        try! self.realm.write {[weak self] in
            guard let self = self else { return }
            self.startProgress()
            var imageName: String = self.peopleEditStruct.item.image
            if self.isChangeImage {
                if let image = self.image {
                    let currentTimeStamp = Int(Date().timeIntervalSince1970)
                    imageName = "\(currentTimeStamp)_people_with"
                    _ = ImageManager.shared.saveImage(image: image, imageName: imageName)
                } else {
                    imageName = ""
                }
            }
            let saveItem = PeopleWith(id: self.peopleEditStruct.item.id, name: self.name, image: imageName, intro: self.intro)
            self.realm.add(saveItem, update: .modified)
            self.stopProgress()
            self.dismiss { [weak self] in
                self?.callback(nil)
            }
        }
    }
    
    func selectImage() {
        self.isChangeImage = true
        self.isChange = true
        self.coordinator?.presentSingleSelectGalleryView(onClickItem: {[weak self] item in
            guard let self = self else { return }
            self.image = item.image
        })
    }
}
