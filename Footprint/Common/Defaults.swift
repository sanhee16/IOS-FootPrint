//
//  Defaults.swift
//  Footprint
//
//  Created by Studio-SJ on 2022/10/05.
//

import Foundation

@propertyWrapper struct UserDefault<T> {
    private let key: String
    private let defaultValue: T
    
    var wrappedValue: T {
        get { (UserDefaults.standard.object(forKey: self.key) as? T) ?? self.defaultValue }
        set { UserDefaults.standard.setValue(newValue, forKey: key) }
    }
    
    init(key: String, defaultValue: T) {
        self.key = key
        self.defaultValue = defaultValue
    }
}

class Defaults {
    @UserDefault<Bool>(key: "LAUNCH_BEFORE", defaultValue: false)
    public static var launchBefore
    
    @UserDefault<[Int]>(key: "SHOWING_CATEGORIES", defaultValue: [-1])
    public static var showingCategories
    
    @UserDefault<Bool>(key: "IS_SET_FILTER", defaultValue: false)
    public static var isSetFilter
    
    @UserDefault<[Int]>(key: "FILTER_PEOPLE_IDS", defaultValue: [])
    public static var filterPeopleIds
    
    @UserDefault<[Int]>(key: "FILTER_CATEGORY_IDS", defaultValue: [])
    public static var filterCategoryIds
    
    @UserDefault<Int>(key: "DELETE_DAYS", defaultValue: 0)
    public static var deleteDays
    
    @UserDefault<Bool>(key: "IS_SHOW_STAR_ONLY", defaultValue: false)
    public static var isShowStarOnly
    
    //MARK: Setting
    /*
     1: On, 0: Off
     8자리까지 채울 수 있음!
     */
    @UserDefault<UInt8>(key: "SETTING_FLAG", defaultValue: 0)
    public static var settingFlag
    
}
