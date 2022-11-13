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
//            for j in i.images {
////                if let dir = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) {
////                    print("dir: \(dir)")
////
////                    print("url2 : \(URL(fileURLWithPath: j))")
////                    print("url2 : \(URL(string: j))")
////                    print("url : \(URL(fileURLWithPath: dir.absoluteString).appendingPathComponent(j).path)")
////                }
//                print(j)
//            }
            self.footPrints.append(i)
        }
        self.stopProgress()
        self.isLoading = false
    }
    
    func onClickAddFootprint() {
        self.coordinator?.changeAddFootprintView(location: self.location, onDismiss: { [weak self] in
            guard let self = self else { return }
            self.coordinator?.presentShowFootPrintView(self.location)
        })
    }
    
    func onClose() {
        self.dismiss()
    }
}
