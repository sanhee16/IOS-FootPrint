//
//  ShowFootPrintViewModel.swift
//  Footprint
//
//  Created by sandy on 2022/11/13.
//

import Foundation
import Combine
import UIKit
import SwiftUIPager
import RealmSwift

class ShowFootPrintViewModel: BaseViewModel {
    
    @Published var footPrints: [FootPrint] = []
    @Published var page: Page = .withIndex(0)
    private let realm: Realm
    private let location: Location
    private var isLoading: Bool = false
    
    
    init(_ coordinator: AppCoordinator, location: Location) {
        self.realm = try! Realm()
        self.location = location
        super.init(coordinator)
    }
    
    func onAppear() {
        self.loadAll()
    }
    
    func loadAll() {
        if isLoading {
            return
        }
        self.startProgress()
        self.isLoading = true
        print("loadAll")
        self.footPrints.removeAll()
        let items = realm.objects(FootPrint.self)
            .filter("latitude == \(location.latitude) AND longitude == \(location.longitude)")
            .sorted(byKeyPath: "createdAt", ascending: true)
        print("\(items.count)")
        for i in items {
            self.footPrints.append(i)
        }
        self.stopProgress()
        self.isLoading = false
    }
    
    func onClickAddFootprint() {
        self.coordinator?.changeAddFootprintView(location: self.location) {
            
        }
    }
    
    func onClose() {
        self.dismiss()
    }
    
//    func getCategory(_ item: FootPrint) -> Category? {
//        let getCategory = realm.objects(Category.self)
//            .sorted(byKeyPath: "tag", ascending: true)
//            .filter { category in
//                return category.tag == item.tag
//            }
//            .first
//        if let getCategory = getCategory {
//            return Category(tag: getCategory.tag, name: getCategory.name, pinType: getCategory.pinType.pinType(), pinColor: getCategory.pinColor.pinColor())
//        }
//        return nil
//    }
}
