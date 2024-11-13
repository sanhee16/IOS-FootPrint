//
//  TripIconRepositoryImpl.swift
//  Footprint
//
//  Created by sandy on 11/13/24.
//

import Foundation
import RealmSwift

class TripIconRepositoryImpl: TripIconRepository {
    func saveTripIcon(icon: TripIcon) -> Result<String, DBError> {
        let realm = try! Realm()
        let item = TripIconDAO(id: UUID().uuidString, iconName: icon.rawValue, isAvailable: true)
        do {
            try realm.write {
                realm.add(item, update: .modified)
            }
            return .success(item.id)
        } catch {
            print("Error during write transaction: \(error.localizedDescription)")
            return .failure(.failToSave)
        }
    }
    
    func deleteTripIcon(id: String) -> Result<String, DBError> {
        let realm = try! Realm()
        
        let deleteItem = realm.objects(TripIconDAO.self)
            .filter { $0.id == id }
            .first
        
        guard let deleteItem = deleteItem else { return .failure(.notFound) }
        
        // 데이터 삭제
        do {
            try realm.write {
                realm.delete(deleteItem)
            }
            return .success(id)
        } catch {
            print("Error during write transaction: \(error.localizedDescription)")
            return .failure(.notFound)
        }
    }
    
    func loadTripIcons() -> Result<[TripIconEntity.DAO], DBError> {
        let realm = try! Realm()
        let list: [TripIconEntity.DAO] = realm.objects(TripIconDAO.self)
            .filter({ $0.isAvailable })
            .map({ $0.toTripIconEntityDao() })
        return list.isEmpty ? .failure(.notFound) : .success(list)
    }
    
    func loadTripIcon(id: String) -> Result<TripIconEntity.DAO, DBError> {
        let realm = try! Realm()
        guard let item: TripIconEntity.DAO = realm.objects(TripIconDAO.self)
            .filter({ $0.id == id })
            .filter({ $0.isAvailable })
            .first?
            .toTripIconEntityDao() else {
            return .failure(.notFound)
        }
        return .success(item)
    }
}
