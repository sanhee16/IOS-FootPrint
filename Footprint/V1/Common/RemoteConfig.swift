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
//        self.remoteConfig.setDefaults(fromPlist: "RemoteConfigValue")
    }
    
    func getRemoteBoolValue(_ key: String, callback: @escaping (Bool)->()) {
        self.remoteConfig.fetch() { (status, error) -> Void in
            if status == .success {
                self.remoteConfig.activate() { (changed, error) in
                    let value = self.remoteConfig[key].boolValue
                    callback(value)
                    print("resultValue=", value)
                }
            } else {
                print("Error: \(error?.localizedDescription ?? "No error available.")")
                callback(false)
            }
        }
    }
    
    func getIsShowAds(_ callback: @escaping (Bool)->()) {
        getRemoteBoolValue("isShowAds") { value in
            callback(value)
        }
    }
}
