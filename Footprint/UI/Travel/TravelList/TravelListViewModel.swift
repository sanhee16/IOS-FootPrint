//
//  TravelListViewModel.swift
//  Footprint
//
//  Created by Studio-SJ on 2022/12/27.
//

import Foundation
import Combine
import UIKit
import RealmSwift

class TravelListViewModel: BaseViewModel {
    private let realm: Realm
    @Published var travels: [Travel] = []
    
    
    override init(_ coordinator: AppCoordinator) {
        self.realm = try! Realm()
        super.init(coordinator)
    }
    
    func onAppear() {
        self.startProgress()
        self.loadAll()
        self.stopProgress()
    }
    
    func onClose() {
        self.dismiss()
    }
    
    func loadAll() {
        self.travels = Array(self.realm.objects(Travel.self))
    }
    
    func onClickShowTravel(_ item: Travel) {
        self.coordinator?.presentShowTravelView(travel: item)
    }
    
    func onClickCreateTravel() {
        self.coordinator?.presentCreateTravelView()
    }
}

