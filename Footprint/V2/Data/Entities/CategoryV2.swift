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
    @Persisted var idx: Int
    @Persisted var name: String
    @Persisted var color: Int // CategoryColor rawValue
    @Persisted var icon: String // CategoryImage rawValue
    
    convenience init(id: String = UUID().uuidString, idx: Int, name: String, color: Int, icon: String) {
        self.init()
        
        self.id = id
        self.idx = idx
        self.name = name
        self.color = color
        self.icon = icon
    }
    
    func toCategoryEntity() -> CategoryEntity {
        return CategoryEntity(
            id: self.id,
            idx: self.idx,
            name: self.name,
            color: CategoryColor(rawValue: self.color)!,
            icon: CategoryIcon(rawValue: self.icon)!
        )
    }
}
