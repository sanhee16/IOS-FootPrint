//
//  AddFootprintViewModel.swift
//  Footprint
//
//  Created by Studio-SJ on 2022/11/04.
//

import Foundation
import Combine
import UIKit

class AddFootprintViewModel: BaseViewModel {
    
    @Published var title: String = ""
    @Published var content: String = ""
    @Published var images: [UIImage] = []
    
    override init(_ coordinator: AppCoordinator) {
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
            print("sandy, item: \(item.image)")
            self.images.append(item.image)
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
}
