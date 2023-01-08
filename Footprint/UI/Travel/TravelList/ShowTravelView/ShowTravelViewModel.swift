//
//  ShowTravelViewModel.swift
//  Footprint
//
//  Created by sandy on 2023/01/08.
//

import Foundation
import Combine
import UIKit
import RealmSwift
import SwiftUI

class ShowTravelViewModel: BaseViewModel {
    private let realm: Realm
    @Published var footprints: [FootPrint] = []
    @Published var expandedItem: FootPrint? = nil
    let travel: Travel
    
    init(_ coordinator: AppCoordinator, travel: Travel) {
        self.realm = try! Realm()
        self.travel = travel
        self.footprints = Array(travel.footprints)
        super.init(coordinator)
        
        self.objectWillChange.send()
    }
    
    func onAppear() {
        
    }
    
    func onClose() {
        self.dismiss()
    }
    
    func loadAllFootprints() {
        
    }
    
    func onClickEdit() {
        
    }
    
    func onClickItem(_ item: FootPrint) {
        if self.expandedItem == item {
            self.expandedItem = nil
            return
        }
        self.expandedItem = item
    }
    
    func showImage(_ idx: Int) {
        guard let item = self.expandedItem else { return }
        var uiImages: [UIImage] = []
        let images = item.images
        for image in images {
            if let uiImage = ImageManager.shared.getSavedImage(named: image) {
                uiImages.append(uiImage)
            }
        }
        self.coordinator?.presentShowImageView(idx, images: uiImages)
    }

    func getPeopleWiths(_ ids: [Int]) -> [PeopleWith] {
        var list: [PeopleWith] = []
        for id in ids {
            if let item = id.getPeopleWith() {
                list.append(item)
            }
        }
        return list
    }
}
