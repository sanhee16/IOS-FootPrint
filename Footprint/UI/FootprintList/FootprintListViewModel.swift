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

class FootprintListViewModel: BaseViewModel {
    
    @Published var list: [FootPrint] = []
    
    private let realm: Realm
    
    
    override init(_ coordinator: AppCoordinator) {
        self.realm = try! Realm()
        super.init(coordinator)
        self.loadAllItems()
    }
    
    func onAppear() {
        
    }
    
    func onClose() {
        self.dismiss()
    }
    
    func onClickFilter() {
        
    }
    
    func loadAllItems() {
        self.list = Array(self.realm.objects(FootPrint.self))
    }
}
