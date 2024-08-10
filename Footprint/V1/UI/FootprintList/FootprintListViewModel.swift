//
//  FootprintListViewModel.swift
//  Footprint
//
//  Created by sandy on 2022/12/10.
//


import Foundation
import Combine
import UIKit
import RealmSwift

class FootprintListViewModel: BaseViewModelV1 {
    
    @Published var list: [FootPrint] = []
    @Published var expandedItem: FootPrint? = nil
    @Published var isShowStarOnly: Bool
    private let realm: Realm
    
    
    override init(_ coordinator: AppCoordinatorV1) {
        self.realm = R.realm
        self.isShowStarOnly = Defaults.isShowStarOnly
        super.init(coordinator)
        self.loadAllItems()
    }
    
    func onAppear() {
        checkNetworkConnect {[weak self] in
            self?.loadAllItems()
        }
    }
    
    func onClose() {
        self.dismiss()
    }
    
    func onClickFilter() {
        self.coordinator?.presentFootprintListFilterView(onDismiss: { [weak self] in
            self?.loadAllItems()
        })
    }
    
    func loadAllItems() {
        let filterPeopleWithIds: [Int] = Defaults.filterPeopleIds
        let filterCategoryIds: [Int] = Defaults.filterCategoryIds
        print("filterPeopleWithIds: \(filterPeopleWithIds), filterCategoryIds: \(filterCategoryIds)")
        
        if self.isShowStarOnly {
            self.list = Array(self.realm.objects(FootPrint.self)
                .filter({footprint in
                    footprint.isStar && footprint.deleteTime == 0
                }))
        } else {
            self.list = Array(self.realm.objects(FootPrint.self)
                .filter({footprint in
                    self.isContain(items: footprint.peopleWithIds, filter: filterPeopleWithIds) && self.isContain(itemId: footprint.tag, filter: filterCategoryIds) && footprint.deleteTime == 0
                }))
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
    
    func onClickShowStarOnly() {
        let change = !self.isShowStarOnly
        Defaults.isShowStarOnly = change
        self.isShowStarOnly = change
        
        self.loadAllItems()
    }
    
    private func isContain(items: List<Int>, filter: [Int]) -> Bool {
        if filter.isEmpty {
            return true
        }
        //filter와 items 중에 하나!라도 일치하면 됨
        for itemId in items {
            if filter.contains(where: { filterId in
                filterId == itemId
            }) {
                return true
            }
        }
        return false
    }
    
    private func isContain(itemId: Int, filter: [Int]) -> Bool {
        if filter.isEmpty {
            return true
        }
        if filter.contains(where: { filterId in
            filterId == itemId
        }) {
            return true
        }
        return false
    }
}
