//
//  MigrationRepositoryImpl.swift
//  Footprint
//
//  Created by sandy on 1/21/25.
//

import Foundation
import RealmSwift

class MigrationRepositoryImpl: MigrationRepository {
    func loadV1Categories() -> Result<[CategoryV1], DBError> {
        let realm = try! Realm()
        let list: [CategoryV1] = realm.objects(Category.self).map({
            $0.toCategoryV1()
        })
        return .success(list)
    }
    
    
    func loadV1Members() -> Result<[MemberV1], DBError> {
        let realm = try! Realm()
        let list: [MemberV1] = realm.objects(PeopleWith.self).map({
            $0.toMemberV1()
        })
        return .success(list)
    }
    
    func loadV1Trips() -> Result<[TripV1], DBError> {
        let realm = try! Realm()
        let list: [TripV1] = realm.objects(Travel.self).map({
            $0.toTripV1()
        })
        return .success(list)
    }
    
    func loadV1Footprints() -> Result<[FootprintV1], DBError> {
        let realm = try! Realm()
        let list: [FootprintV1] = realm.objects(FootPrint.self).map({
            $0.toFootprintV1()
        })
        return .success(list)
    }
}
