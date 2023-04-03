//
//  RemoteConfig.swift
//  Footprint
//
//  Created by Studio-SJ on 2023/04/03.
//

import Foundation
import FirebaseRemoteConfig

class Remote {
    let remoteConfig: RemoteConfig
    
    init() {
        self.remoteConfig = RemoteConfig.remoteConfig()
        
        let settings = RemoteConfigSettings()
        settings.minimumFetchInterval = 0
        
        self.remoteConfig.configSettings = settings
        self.remoteConfig.setDefaults(fromPlist: "RemoteConfigValue")
    }
    
    func isShowAds() -> Bool {
        return self.remoteConfig["isShowAds"].boolValue
    }
}
