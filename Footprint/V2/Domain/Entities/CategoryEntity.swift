//
//  CategoryEntity.swift
//  Footprint
//
//  Created by sandy on 10/24/24.
//

struct CategoryEntity: Equatable, Hashable {
    var id: String
    var idx: Int
    var name: String
    var color: CategoryColor
    var icon: CategoryIcon
}
