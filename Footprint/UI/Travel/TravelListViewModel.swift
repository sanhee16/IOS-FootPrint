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
        self.realm = R.realm
        super.init(coordinator)
    }
    
    func onAppear() {
        checkNetworkConnect {[weak self] in
            guard let self = self else { return }
            self.startProgress()
            self.loadAll()
            self.stopProgress()
        }
    }
    
    func onClose() {
        self.dismiss()
    }
    
    func loadAll() {
        self.startProgress()
        self.travels.removeAll()
        self.travels = Array(self.realm.objects(Travel.self)).filter({ item in
            item.deleteTime == 0
        })
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

