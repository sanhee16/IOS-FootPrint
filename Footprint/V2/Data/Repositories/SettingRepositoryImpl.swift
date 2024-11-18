//
//  SettingRepositoryImpl.swift
//  Footprint
//
//  Created by sandy on 11/8/24.
//

import Foundation

class SettingRepositoryImpl: SettingRepository {
    let userDefaultsManager: Defaults
    
    init(userDefaultsManager: Defaults) {
        self.userDefaultsManager = userDefaultsManager
    }
    
    func updateIsShowMarker(_ isShow: Bool) {
        self.userDefaultsManager.isShowMarker = isShow
    }
    
    func getIsShowMarker() -> Bool {
        self.userDefaultsManager.isShowMarker
    }
    
    func updateTripSortType(_ value: Int) {
        self.userDefaultsManager.tripSortType = value
    }
    
    func getTripSortType() -> Int {
        self.userDefaultsManager.tripSortType
    }
    
    func updateFootprintSortType(_ value: Int) {
        self.userDefaultsManager.footprintSortType = value
    }
    
    func getFootprintSortType() -> Int {
        self.userDefaultsManager.footprintSortType
    }
    
}
