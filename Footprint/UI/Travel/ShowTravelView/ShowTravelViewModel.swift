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
    @Published var travel: Travel
    
    init(_ coordinator: AppCoordinator, travel: Travel) {
        self.realm = R.realm
        self.travel = travel
        self.footprints = Array(travel.footprints)
        super.init(coordinator)
    }
    
    func onAppear() {
        
    }
    
    func onClose() {
        self.dismiss()
    }
    
    func loadAllFootprints() {
        
    }
    
    func onClickEdit() {
        self.coordinator?.presentEditTravelView(.edit(item: self.travel)) { [weak self] in
            self?.reloadTravel()
        }
    }
    
    private func reloadTravel() {
        guard let travel = self.realm.objects(Travel.self).filter({ item in
            item.id == self.travel.id
        }).first else {
            return
        }
        self.startProgress()
        self.travel = travel
        self.footprints = Array(self.travel.footprints)
        self.stopProgress()
    }
    
    func onClickDeleteTravel() {
        self.alert(.yesOrNo, title: "alert_delete".localized(), description: "alert_delete_item".localized("\(Defaults.deleteDays)")) {[weak self] isDelete in
            guard let self = self else { return }
            if isDelete {
                guard let item = self.realm.object(ofType: Travel.self, forPrimaryKey: self.travel.id) else {
                    self.alert(.ok, title: "alert_fail".localized())
                    return
                }
                try! self.realm.write {[weak self] in
                    guard let self = self else { return }
                    item.deleteTime = Int(Date().timeIntervalSince1970)
                    self.realm.add(item, update: .modified)
                    self.stopProgress()
                    self.dismiss()
                }
            } else {
                return
            }
        }
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
