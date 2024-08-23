//
//  UserDefault.swift
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
