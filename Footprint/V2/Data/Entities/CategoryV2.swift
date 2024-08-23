//
//  CategoryV2.swift
//  Footprint
//
//  Created by sandy on 8/23/24.
//

import Foundation
import RealmSwift

class CategoryV2: Object {
    @Persisted(primaryKey: true) var id: String
    @Persisted var name: String
    @Persisted var color: String // hex
    @Persisted var icon: String // icon name
    
    convenience init(id: String? = UUID().uuidString, name: String, color: String, icon: String) {
        self.init()
        
        self.id = id ?? UUID().uuidString
        self.name = name
        self.color = color
        self.icon = icon
    }
}
