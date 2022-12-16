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
    case new(name: String)
    case modify(item: PeopleWith)
}

class PeopleEditViewModel: BaseViewModel {
    let type: PeopleEditType
    @Published var name: String = ""
    @Published var image: UIImage? = nil
    @Published var intro: String = ""
    private let realm: Realm
    var isChangeImage: Bool = false
    
    init(_ coordinator: AppCoordinator, type: PeopleEditType) {
        self.type = type
        self.realm = try! Realm()
        super.init(coordinator)
        if case .modify(let item) = type {
            self.name = item.name
            self.image = ImageManager.shared.getSavedImage(named: item.image)
            self.intro = item.intro
        } else if case .new(let name) = type {
            self.name = name
        }
    }
    
    func onAppear() {
        
    }
    
    func onClose() {
        self.alert(.yesOrNo, title: "저장하지 않고 나가시겠습니까?") {[weak self] res in
            guard let self = self else { return }
            if res {
                self.dismiss()
            } else {
                return
            }
        }
    }
    
    func deleteItem() {
        if case .modify(let item) = type {
            self.startProgress()
            let deleteItem = PeopleWith(id: item.id, name: item.name, image: item.image, intro: item.intro)
            try! self.realm.write {[weak self] in
                self?.realm.delete(deleteItem)
                self?.stopProgress()
                self?.dismiss()
            }
        } else {
            return
        }
    }
    
    func addItem() {
        if type == .new(name: self.name) {
            var id: Int = 0
            if self.realm.objects(PeopleWith.self).isEmpty {
                id = 0
            } else if let lastItem = self.realm.objects(PeopleWith.self).last {
                id = lastItem.id + 1
            } else {
                return
            }
            self.startProgress()
            var imageName: String = ""
            if let image = self.image {
                let currentTimeStamp = Int(Date().timeIntervalSince1970)
                imageName = "\(currentTimeStamp)_people_with"
                _ = ImageManager.shared.saveImage(image: image, imageName: imageName)
            }
            let addItem = PeopleWith(id: id, name: self.name, image: imageName, intro: self.intro)
            try! self.realm.write {[weak self] in
                self?.realm.add(addItem)
                self?.stopProgress()
                self?.dismiss()
            }
        }
    }
    
    func saveItem() {
        if case .modify(let item) = type {
            self.startProgress()
            var imageName: String = item.image
            if self.isChangeImage {
                if let image = self.image {
                    let currentTimeStamp = Int(Date().timeIntervalSince1970)
                    imageName = "\(currentTimeStamp)_people_with"
                    _ = ImageManager.shared.saveImage(image: image, imageName: imageName)
                } else {
                    imageName = ""
                }
            }
            let saveItem = PeopleWith(id: item.id, name: self.name, image: imageName, intro: self.intro)
            try! self.realm.write {[weak self] in
                self?.realm.add(saveItem, update: .modified)
                self?.stopProgress()
                self?.dismiss()
            }
        } else {
            return
        }
    }
    
    func selectImage() {
        self.isChangeImage = true
        self.coordinator?.presentSingleSelectGalleryView(onClickItem: {[weak self] item in
            guard let self = self else { return }
            self.image = item.image
        })
    }
    
    func onClickImage() {
        self.isChangeImage = true
        self.image = nil
    }
}
