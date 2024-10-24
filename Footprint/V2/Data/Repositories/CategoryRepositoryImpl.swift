//
//  CategoryRepositoryImpl.swift
//  Footprint
//
//  Created by sandy on 8/23/24.
//

import Foundation
import RealmSwift

class CategoryRepositoryImpl: CategoryRepository {
    func addCategory(_ id: String?, name: String, color: Int, icon: Int) {
        let realm = try! Realm()
        let item = CategoryV2(id: id, name: name, color: color, icon: icon)
        do {
            try realm.write {
                realm.add(item, update: .modified)
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
    
    func loadCategories() -> [CategoryEntity] {
        let realm = try! Realm()
        var list: [CategoryEntity] = []
        realm.objects(CategoryV2.self).forEach { c in
            list.append(CategoryV2(id: c.id, name: c.name, color: c.color, icon: c.icon).toCategoryEntity())
        }
        return list
    }
    
    func loadCategory(_ id: String) -> CategoryEntity? {
        let realm = try! Realm()
        let c = realm.objects(CategoryV2.self).where({ $0.id == id }).first
        guard let c = c else { return nil }
        let result = CategoryV2(id: c.id, name: c.name, color: c.color, icon: c.icon).toCategoryEntity()
        return result
    }
}
