//
//  Defaults.swift
//  Footprint
//
//  Created by Studio-SJ on 2022/10/05.
//

import Foundation

class Defaults {
    private static let LAUNCH_BEFORE = "LAUNCH_BEFORE"
    public static var launchBefore: Bool {
        get {
            UserDefaults.standard.bool(forKey: LAUNCH_BEFORE)
        }
        set(value) {
            UserDefaults.standard.setValue(value, forKey: LAUNCH_BEFORE)
        }
    }
}
