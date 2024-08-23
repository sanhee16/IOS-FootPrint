//
//  RealCategoryRepository.swift
//  Footprint
//
//  Created by sandy on 8/23/24.
//

import Foundation
import RealmSwift

class RealCategoryRepository: CategoryRepository {
    func addCategory(_ category: CategoryV2) {
        let realm = try! Realm()
        
        do {
            try realm.write {
                realm.add(category, update: .modified)
            }
        } catch {
            print("Error during write transaction: \(error.localizedDescription)")
        }
    }
    
    func deleteCategory(_ id: String) {
        let realm = try! Realm()
        
        // 데이터를 가져와서 필터링
        let deleteItem = realm.objects(CategoryV2.self)
            .filter { $0.id == id }
            .first
        guard let deleteItem = deleteItem else { return }
        
        // 데이터 삭제
        try! realm.write {
            realm.delete(deleteItem)
        }
    }
    
    func loadCategories() -> [CategoryV2] {
        let realm = try! Realm()
        let list = Array(realm.objects(CategoryV2.self))
        return list
    }
}
