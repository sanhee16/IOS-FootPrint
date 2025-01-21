//
//  UserDefaultsManager.swift
//  Footprint
//
//  Created by sandy on 8/23/24.
//

import Foundation

enum UserDefaultKey: String {
    case firstLaunch = "FIRST_LAUNCH"
    case launchBefore = "LAUNCH_BEFORE"
    case showingCategories = "SHOWING_CATEGORIES"
    case isSetFilter = "IS_SET_FILTER"
    case filterPeopleIds = "FILTER_PEOPLE_IDS"
    case filterCategoryIds = "FILTER_CATEGORY_IDS"
    case deleteDays = "DELETE_DAYS"
    case isShowStarOnly = "IS_SHOW_STAR_ONLY"
    case premiumCode = "PREMIUM_CODE"
    case settingFlag = "SETTING_FLAG"
    case isShowMarker = "IS_SHOW_MARKER"
    case tripSortType = "TRIP_SORT_TYPE"
    case footprintSortType = "FOOTPRINT_SORT_TYPE"
    case isShowSearchBar = "IS_SHOW_SEARCH_BAR"
    case isCompleteMigrationV2 = "IS_COMPLETE_MIGRATION_V2"
}


class Defaults {
    static let shared: Defaults = Defaults()
    init() {
        
    }
    @UserDefault<Bool>(key: UserDefaultKey.firstLaunch.rawValue, defaultValue: true)
    var firstLaunch
    
    @UserDefault<Bool>(key: UserDefaultKey.launchBefore.rawValue, defaultValue: false)
    var launchBefore
    
    @UserDefault<[Int]>(key: UserDefaultKey.showingCategories.rawValue, defaultValue: [-1])
    var showingCategories
    
    @UserDefault<Bool>(key: UserDefaultKey.isSetFilter.rawValue, defaultValue: false)
    var isSetFilter
    
    @UserDefault<[Int]>(key: UserDefaultKey.filterPeopleIds.rawValue, defaultValue: [])
    var filterPeopleIds
    
    @UserDefault<[Int]>(key: UserDefaultKey.filterCategoryIds.rawValue, defaultValue: [])
    var filterCategoryIds
    
    @UserDefault<Int>(key: UserDefaultKey.deleteDays.rawValue, defaultValue: 0)
    var deleteDays
    
    @UserDefault<Bool>(key: UserDefaultKey.isShowStarOnly.rawValue, defaultValue: false)
    var isShowStarOnly
    
    @UserDefault<String>(key: UserDefaultKey.premiumCode.rawValue, defaultValue: "")
    var premiumCode
    
    @UserDefault<Bool>(key: UserDefaultKey.isShowMarker.rawValue, defaultValue: true)
    var isShowMarker
    
    @UserDefault<Int>(key: UserDefaultKey.tripSortType.rawValue, defaultValue: 0)
    var tripSortType
    
    @UserDefault<Int>(key: UserDefaultKey.footprintSortType.rawValue, defaultValue: 0)
    var footprintSortType
    
    @UserDefault<Bool>(key: UserDefaultKey.isShowSearchBar.rawValue, defaultValue: true)
    var isShowSearchBar
    
    @UserDefault<Bool>(key: UserDefaultKey.isCompleteMigrationV2.rawValue, defaultValue: false)
    var isCompleteMigrationV2
    
    //MARK: Setting
    /*
     1: On, 0: Off
     8자리까지 채울 수 있음!
     */
    @UserDefault<UInt8>(key: UserDefaultKey.settingFlag.rawValue, defaultValue: 0)
    var settingFlag
}
