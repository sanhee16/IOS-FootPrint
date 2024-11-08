//
//  CategoryRepository.swift
//  Footprint
//
//  Created by sandy on 8/23/24.
//

import Foundation
import RealmSwift

protocol CategoryRepository {
    func addCategory(_ id: String?, name: String, color: Int, icon: String, isDeletable: Bool)
    func updateCategory(_ id: String, idx: Int, name: String, color: Int, icon: String, isDeletable: Bool)
    func deleteCategory(_ id: String) -> Bool
    func loadCategories() -> [CategoryEntity]
    func loadCategory(_ id: String) -> CategoryEntity?
    func updateOrder(_ categories: [CategoryEntity])
}

