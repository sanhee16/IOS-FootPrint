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
}
