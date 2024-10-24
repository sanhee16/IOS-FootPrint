//
//  CategoryEntity.swift
//  Footprint
//
//  Created by sandy on 10/24/24.
//

struct CategoryEntity: Equatable, Hashable {
    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.id == rhs.id
    }
    var id: String?
    var name: String
    var color: CategoryColor
    var icon: CategoryIcon
    
    init(id: String? = nil, name: String, color: CategoryColor, icon: CategoryIcon) {
        self.id = id
        self.name = name
        self.color = color
        self.icon = icon
    }
}
