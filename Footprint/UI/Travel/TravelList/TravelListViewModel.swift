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
    
    func onClickMenu(_ type: MainMenuType) {
        switch type {
        case .map:
            self.coordinator?.presentMain()
        case .footprints:
            self.coordinator?.presentFootprintListView()
        case .travel:
            break
        case .setting:
            self.coordinator?.presentSettingView()
        }
    }
    
    func loadAll() {
        self.startProgress()
        self.travels.removeAll()
        self.travels = Array(self.realm.objects(Travel.self))
        self.stopProgress()
    }
    
    func onClickShowTravel(_ item: Travel) {
        self.coordinator?.presentShowTravelView(travel: item) {[weak self] in
            self?.loadAll()
        }
    }
    
    func onClickCreateTravel() {
        self.coordinator?.presentEditTravelView(.create)
    }
}

