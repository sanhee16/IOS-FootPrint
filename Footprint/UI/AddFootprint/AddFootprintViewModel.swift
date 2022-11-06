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
    private let location: Location
    private let realm: Realm
    
    init(_ coordinator: AppCoordinator, location: Location) {
        self.realm = try! Realm()
        self.location = location
        super.init(coordinator)
    }
    
    func onAppear() {
        
    }
    
    func onClose() {
        self.alert(.yesOrNo, title: nil, description: "저장하지 않고 나가시겠습니까?") {[weak self] isClose in
            guard let self = self else { return }
            if isClose {
                self.dismiss()
            }
        }
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
            let url = ImageManager.shared.saveImage(image: self.images[idx], imageName: "\(currentTimeStamp)_\(idx)")
            if let url = url {
                print("savedUrl : \(url)")
                imageUrls.append(url)
            }
        }
        
        try! realm.write {
            realm.add(FootPrint(title: self.title, content: self.content, images: imageUrls, latitude: self.location.latitude, longitude: self.location.longitude))
            self.stopProgress()
            self.onClose()
        }
    }
}
