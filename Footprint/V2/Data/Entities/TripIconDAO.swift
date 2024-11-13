//
//  TripIconDAO.swift
//  Footprint
//
//  Created by sandy on 11/13/24.
//

import RealmSwift

class TripIconDAO: Object {
    @Persisted(primaryKey: true) var id: String
    @Persisted var iconName: String
    @Persisted var isAvailable: Bool
    
    convenience init(id: String, iconName: String, isAvailable: Bool) {
        self.init()
        
        self.id = id
        self.iconName = iconName
        self.isAvailable = isAvailable
    }
    
    func toTripIconEntityDao() -> TripIconEntity.DAO {
        return TripIconEntity.DAO(id: self.id, iconName: self.iconName)
    }
}
