//
//  CategoryRepositoryImpl.swift
//  Footprint
//
//  Created by sandy on 8/23/24.
//

import Foundation
import RealmSwift

class CategoryRepositoryImpl: CategoryRepository {
    func addCategory(_ id: String?, name: String, color: Int, icon: String, isDeletable: Bool) {
        let realm = try! Realm()
        let lastIdx: Int = (realm.objects(CategoryV2.self).map({ $0.idx }).max() ?? 0)
        
        let item = CategoryV2(id: id ?? UUID().uuidString, idx: lastIdx + 1, name: name, color: color, icon: icon, isDeletable: isDeletable)
        do {
            try realm.write {
                realm.add(item, update: .modified)
            }
        } catch {
            print("Error during write transaction: \(error.localizedDescription)")
        }
    }
    
    func updateCategory(_ id: String, idx: Int, name: String, color: Int, icon: String, isDeletable: Bool) {
        let realm = try! Realm()
        let item = CategoryV2(id: id, idx: idx, name: name, color: color, icon: icon, isDeletable: isDeletable)
        do {
            try realm.write {
                realm.add(item, update: .modified)
            }
        } catch {
            print("Error during write transaction: \(error.localizedDescription)")
        }
    }
    
    func deleteCategory(_ id: String) -> Bool {
        let realm = try! Realm()
        
        // 데이터를 가져와서 필터링
        let deleteItem = realm.objects(CategoryV2.self)
            .filter { $0.id == id }
            .first
        guard let deleteItem = deleteItem, deleteItem.isDeletable else { return false }
        
        // 데이터 삭제
        try! realm.write {
            realm.delete(deleteItem)
        }
        return true
    }
    
    func loadCategories() -> [CategoryEntity] {
        let realm = try! Realm()
        var list: [CategoryEntity] = []
        realm.objects(CategoryV2.self).sorted(by: { lhs, rhs in
            lhs.idx < rhs.idx
        }).forEach { c in
            list.append(CategoryV2(id: c.id, idx: c.idx, name: c.name, color: c.color, icon: c.icon, isDeletable: c.isDeletable).toCategoryEntity())
        }
        return list
    }
    
    func loadCategory(_ id: String) -> CategoryEntity? {
        let realm = try! Realm()
        let c = realm.objects(CategoryV2.self).where({ $0.id == id }).first
        guard let c = c else { return nil }
        let result = CategoryV2(id: c.id, idx: c.idx, name: c.name, color: c.color, icon: c.icon, isDeletable: c.isDeletable).toCategoryEntity()
        return result
    }
    
    func updateOrder(_ categories: [CategoryEntity]) {
        let realm = try! Realm()
        
        try! realm.write {
            let preList = realm.objects(CategoryV2.self)
            let postList = categories.map({
                CategoryV2(id: $0.id, idx: 0, name: $0.name, color: $0.color.rawValue, icon: $0.icon.rawValue, isDeletable: $0.isDeletable)
            })
            postList.indices.forEach { i in
                postList[i].idx = i
            }
            preList.forEach { item in
                realm.delete(item)
            }
            postList.forEach { item in
                realm.add(item, update: .modified)
            }
        }
    }
}
