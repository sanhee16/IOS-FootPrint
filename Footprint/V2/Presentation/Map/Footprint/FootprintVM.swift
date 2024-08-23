//
//  FootprintVM.swift
//  Footprint
//
//  Created by sandy on 8/10/24.
//

import Foundation
import Combine
import UIKit
import SwiftUI
import SwiftUIPullToRefresh
import SwiftUIPager
import RealmSwift
import SwiftUI
import SDSwiftUIPack

class FootprintVM: BaseViewModel {
    @Published var footPrints: [FootPrint] = []
    @Published var page: Page
    @Published var pageIdx: Int = 0
    private let realm: Realm
    private var location: Location?
    private var isLoading: Bool = false
    
    override init() {
        self.realm = R.realm
        self.location = nil
        self.page = .withIndex(0)
        self.pageIdx = 0
        super.init()
        self.page.update(.new(index: 0))
    }
    
    func onAppear() {
        
    }
    
    func updateLocation(_ location: Location) {
        self.location = location
        self.loadAll()
    }
    
    func loadAll() {
        guard let location = self.location else { return }
        if isLoading {
            return
        }
        
        self.isLoading = true
        print("loadAll")
        self.footPrints.removeAll()
        let items = realm.objects(FootPrint.self)
            .filter("latitude == \(location.latitude) AND longitude == \(location.longitude) AND deleteTime == 0")
            .sorted(byKeyPath: "createdAt", ascending: true)
        print("\(items.count)")
        print("\(items)")
        for i in items {
            self.footPrints.append(i)
        }
        
        self.isLoading = false
    }
    
    func onClickAddFootprint() {
        let placeId: String? = footPrints.first?.placeId
        let address: String? = footPrints.first?.address
//        self.coordinator?.changeAddFootprintView(location: self.location, type: .new(name: nil, placeId: placeId, address: address)) {
//        }
    }
    
    func onClickDeleteFootprint() {
        let deleteId = self.footPrints[pageIdx].id
        
//        self.alert(.yesOrNo, title: "alert_delete".localized(), description: "alert_delete_item".localized("\(Defaults.shared.deleteDays)")) {[weak self] isDelete in
//            guard let self = self else { return }
//            if isDelete {
//                guard let item = self.realm.object(ofType: FootPrint.self, forPrimaryKey: deleteId) else {
//                    self.alert(.ok, title: "alert_fail".localized())
//                    return
//                }
//                try! self.realm.write {[weak self] in
//                    guard let self = self else { return }
//                    item.deleteTime = Int(Date().timeIntervalSince1970)
//                    self.realm.add(item, update: .modified)
//                    self.dismiss()
//                }
//            } else {
//                return
//            }
//        }
    }
    
    func onClickModifyFootprint() {
        let item = self.footPrints[pageIdx]
        guard let category = item.tag.getCategory() else {
            return
        }
        var uiImages: [UIImage] = []
        for image in item.images {
            if let uiImage = ImageManager.shared.getSavedImage(named: image) {
                uiImages.append(uiImage)
            } else {
                print("failed")
            }
        }
        
        
        //        var peopleWith: [PeopleWith] = item.peopleWithIds
        //        let realm = try! Realm()
        if let footprint = self.realm.object(ofType: FootPrint.self, forPrimaryKey: item.id) {
            var peopleWith: [PeopleWith] = []
            for i in footprint.peopleWithIds {
                if let peopleWithItem = i.getPeopleWith() {
                    peopleWith.append(peopleWithItem)
                }
            }
            print("peopleWith: \(peopleWith)")
            
//            self.coordinator?.changeAddFootprintView(location: self.location, type: .modify(content: FootprintContents(title: item.title, content: item.content, createdAt: Date(timeIntervalSince1970: Double(item.createdAt)), images: uiImages, category: category, peopleWith: peopleWith, id: item.id, isStar: item.isStar))) {
//            }
        }
    }
    
    func onClose() {
//        self.dismiss()
    }
    
    func moveNext() {
        if self.page.index + 1 >= self.footPrints.count {
            return
        }
        withAnimation { [weak self] in
            guard let self = self else { return }
            self.page.update(.next)
            self.pageIdx = self.page.index
        }
    }
    
    func moveBefore() {
        if self.page.index - 1 < 0 {
            return
        }
        withAnimation { [weak self] in
            guard let self = self else { return }
            self.page.update(.previous)
            self.pageIdx = self.page.index
        }
    }
    
    func showImage(_ idx: Int) {
        var uiImages: [UIImage] = []
        let images = self.footPrints[self.pageIdx].images
        for image in images {
            if let uiImage = ImageManager.shared.getSavedImage(named: image) {
                uiImages.append(uiImage)
            }
        }
//        self.coordinator?.presentShowImageView(idx, images: uiImages)
    }
    
    func getPeopleWith(_ list: [Int]) -> [PeopleWith] {
        var result: [PeopleWith] = []
        for i in list {
            if let item = i.getPeopleWith() {
                result.append(item)
            }
        }
        return result
    }
}
