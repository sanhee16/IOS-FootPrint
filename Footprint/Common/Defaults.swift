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
    
    private static let SHOWING_CATEGORIES = "SHOWING_CATEGORIES"
    public static var showingCategories: [Int] {
        get {
            (UserDefaults.standard.array(forKey: SHOWING_CATEGORIES) as? [Int]) ?? [-1]
        }
        set(value) {
            UserDefaults.standard.setValue(value, forKey: SHOWING_CATEGORIES)
        }
    }
    
    private static let IS_SET_FILTER = "IS_SET_FILTER"
    public static var isSetFilter: Bool {
        get {
            UserDefaults.standard.bool(forKey: IS_SET_FILTER)
        }
        set(value) {
            UserDefaults.standard.setValue(value, forKey: IS_SET_FILTER)
        }
    }
    
    private static let FILTER_PEOPLE_IDS = "FILTER_PEOPLE_IDS"
    public static var filterPeopleIds: [Int] {
        get {
            (UserDefaults.standard.array(forKey: FILTER_PEOPLE_IDS) as? [Int]) ?? []
        }
        set(value) {
            UserDefaults.standard.setValue(value, forKey: FILTER_PEOPLE_IDS)
        }
    }
    
    private static let FILTER_CATEGORY_IDS = "FILTER_CATEGORY_IDS"
    public static var filterCategoryIds: [Int] {
        get {
            (UserDefaults.standard.array(forKey: FILTER_CATEGORY_IDS) as? [Int]) ?? []
        }
        set(value) {
            UserDefaults.standard.setValue(value, forKey: FILTER_CATEGORY_IDS)
        }
    }
    
    //MARK: Setting
    /*
     1: On, 0: Off
     8자리까지 채울 수 있음!
     */
    private static let SETTING_FLAG = "SETTING_FLAG"
    public static var SettingFlag: UInt8? {
        get {
            UserDefaults.standard.object(forKey: SETTING_FLAG) as? UInt8
        }
        set(value) {
            UserDefaults.standard.setValue(value, forKey: SETTING_FLAG)
        }
    }
}
