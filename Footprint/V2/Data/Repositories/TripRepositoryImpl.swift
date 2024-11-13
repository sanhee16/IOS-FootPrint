//
//  TripRepositoryImpl.swift
//  Footprint
//
//  Created by sandy on 11/13/24.
//

import Foundation
import RealmSwift

class TripRepositoryImpl: TripRepository {
    func saveTrip(title: String, content: String, iconId: String, footprintIds: [String], startAt: Int, endAt: Int) -> Result<String, DBError> {
        let realm = try! Realm()
        var ids: List<String> = List()
        footprintIds.forEach({ ids.append($0) })
        
        let item = TripDAO(
            id: UUID().uuidString,
            title: title,
            content: content,
            iconId: iconId,
            footprintIds: ids,
            startAt: startAt,
            endAt: endAt,
            createdAt: Int(Date().timeIntervalSince1970)
        )
        
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
    
    func updateTrip(id: String, title: String, content: String, iconId: String, footprintIds: [String], startAt: Int, endAt: Int) -> Result<String, DBError> {
        let realm = try! Realm()
        var ids: List<String> = List()
        footprintIds.forEach({ ids.append($0) })
        let createdAt = realm.objects(TripDAO.self)
            .filter { $0.id == id }
            .first?.createdAt
        
        let item = TripDAO(
            id: id,
            title: title,
            content: content,
            iconId: iconId,
            footprintIds: ids,
            startAt: startAt,
            endAt: endAt,
            createdAt: createdAt ?? Int(Date().timeIntervalSince1970)
        )
        
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
    
    func deleteTrip(_ id: String) -> Result<String, DBError> {
        let realm = try! Realm()
        
        let deleteItem = realm.objects(TripDAO.self)
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
    
    func loadTrips() -> Result<[TripEntity.DAO], DBError> {
        let realm = try! Realm()
        let list: [TripEntity.DAO] = realm.objects(TripDAO.self).map({ $0.toTripEntityDao() })
        return .success(list)
    }
    
    func loadTrip(_ id: String) -> Result<TripEntity.DAO, DBError> {
        let realm = try! Realm()
        guard let item: TripEntity.DAO = realm.objects(TripDAO.self).filter({ $0.id == id }).first?.toTripEntityDao() else {
            return .failure(.notFound)
        }
        return .success(item)
    }
    
    
}
