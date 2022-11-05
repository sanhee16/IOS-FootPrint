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
    private let realm: Realm
    
    override init(_ coordinator: AppCoordinator) {
        self.realm = try! Realm()
        super.init(coordinator)
    }
    
    func onAppear() {
        
    }
    
    func onClose() {
        self.dismiss()
    }
    
    func onClickGallery() {
        self.coordinator?.presentGalleryView(onClickItem: { [weak self] (item: GalleryItem) in
            guard let self = self else { return }
            if !self.images.contains(item.image) {
                self.images.append(item.image)
            }
        })
    }
    
    func removeImage(_ item: UIImage) {
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
        if self.title.isEmpty {
            self.alert(.ok, title: "title을 적어주세요")
            return
        } else if self.content.isEmpty {
            self.alert(.ok, title: "내용을 적어주세요")
            return
        }
        // image save
        self.startProgress()
        let imageUrls: List<String> = List<String>()
        let currentTimeStamp = Int(Date().timeIntervalSince1970)
        for idx in self.images.indices {
            let url = ImageManager.shared.saveImage(image: self.images[idx], imageName: "\(currentTimeStamp)_\(idx)")
            if let url = url {
                print("savedUrl : \(url)")
                imageUrls.append(url)
            }
        }
        
        try! realm.write {
            realm.add(FootPrint(title: self.title, content: self.content, images: imageUrls))
            self.stopProgress()
            self.onClose()
        }
    }
}
