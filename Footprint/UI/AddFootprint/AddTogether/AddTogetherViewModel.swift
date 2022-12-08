//
//  AddTogetherViewModel.swift
//  Footprint
//
//  Created by Studio-SJ on 2022/12/08.
//

import Foundation
import Combine
import RealmSwift


struct AddTogetherType {
    enum AddType: Equatable {
        case create
        case update
    }
    var type: AddType
    let together: Together?
}

class AddTogetherViewModel: BaseViewModel {
    private let realm: Realm
    @Published var isAvailableSave: Bool
    
    @Published var name: String = ""
    @Published var imageUrl: String? = nil
    
    @Published var isKeyboardVisible = false
    @Published var type: AddTogetherType
    private var onEraseTogether: (()->())?
    
    init(_ coordinator: AppCoordinator, type: AddTogetherType, onEraseTogether: (()->())?) {
        self.type = type
        self.realm = try! Realm()
        self.isAvailableSave = type.type == .update
        self.onEraseTogether = onEraseTogether
        super.init(coordinator)
        if self.type.type == .update, let item = self.type.together {
            self.name = item.name
            self.imageUrl = item.image
        }
    }
    
    func onAppear() {
        
    }
    
    func onClose() {
        self.isKeyboardVisible = false
        self.dismiss()
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
            if let together = self.type.together, let item = self.realm.object(ofType: Together.self, forPrimaryKey: together.id) {
                try! self.realm.write {
                    item.name = self.name
                    item.image = self.imageUrl
                    
                    self.realm.add(item, update: .modified)
                    self.stopProgress()
                    self.dismiss(animated: true)
                }
            }
        case .create:
            self.startProgress()
            print("create")
            try! realm.write {
                let item = Together(name: self.name, image: self.imageUrl)
                realm.add(item)
                self.stopProgress()
                self.dismiss(animated: true)
            }
        }
    }
    
    func onClickDelete() {
        if let together = self.type.together {
            self.alert(.yesOrNo, title: "함께한 사람을 삭제하시겠습니까?", description: "함께한 사람을 삭제해도 기존에 있던 노트는 유지된 채 사람만 제거됩니다.") {[weak self] isDelete in
                guard let self = self else { return }
                let items = self.realm.objects(FootPrint.self)
                    .filter { footPrint in
                        footPrint.togethers.contains { str in
                            str == together.name
                        }
                    }
                if isDelete {
                    try! self.realm.write {
                        for item in items {
                            if let idx = item.togethers.index(of: together.name) {
                                var newTogether = item.togethers
                                newTogether.remove(at: idx)
                                item.togethers = newTogether
                                self.realm.add(item, update: .modified)
                            }
                        }
                        self.dismiss(animated: true) { [weak self] in
                            self?.onEraseTogether?()
                        }
                    }
                }
            }
        } else {
            self.alert(.ok, title: "오류가 발생했습니다.", description: "잠시 후 다시 시도해 주세요.")
        }
    }
    
    func onClickGallery() {
        //TODO: 갤러리 이미지 하나만 선택해야하는거 type 만들기!!
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
}
