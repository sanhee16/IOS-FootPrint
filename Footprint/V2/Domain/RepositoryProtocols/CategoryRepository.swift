//
//  CategoryRepository.swift
//  Footprint
//
//  Created by sandy on 8/23/24.
//

import Foundation
import RealmSwift

protocol CategoryRepository {
    func addCategory(_ category: CategoryV2)
    func deleteCategory(_ id: String)
    func loadCategories() -> [CategoryV2]
    func loadCategory(_ id: String) -> CategoryV2?
}

