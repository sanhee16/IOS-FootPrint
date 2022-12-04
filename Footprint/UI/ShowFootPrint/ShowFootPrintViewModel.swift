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
import SwiftUI

class ShowFootPrintViewModel: BaseViewModel {
    
    @Published var footPrints: [FootPrint] = []
    @Published var page: Page
    @Published var pageIdx: Int = 0
    private let realm: Realm
    private let location: Location
    private var isLoading: Bool = false
    
    
    init(_ coordinator: AppCoordinator, location: Location) {
        self.realm = try! Realm()
        self.location = location
        self.page = .withIndex(0)
        self.pageIdx = 0
        super.init(coordinator)
        self.page.update(.new(index: 0))
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
}
