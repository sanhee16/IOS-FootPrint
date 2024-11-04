//
//  CategoryRepository.swift
//  Footprint
//
//  Created by sandy on 8/23/24.
//

import Foundation
import RealmSwift

protocol CategoryRepository {
    func addCategory(_ id: String?, name: String, color: Int, icon: String)
    func deleteCategory(_ id: String)
    func loadCategories() -> [CategoryEntity]
    func loadCategory(_ id: String) -> CategoryEntity?
}

