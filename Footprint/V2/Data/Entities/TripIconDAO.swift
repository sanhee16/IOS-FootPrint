//
//  TripIconDAO.swift
//  Footprint
//
//  Created by sandy on 11/13/24.
//

import RealmSwift

class TripIconDAO: Object {
    @Persisted(primaryKey: true) var id: String
    @Persisted var icon: String
    @Persisted var isAvailable: Bool
    
    convenience init(id: String, icon: String, isAvailable: Bool) {
        self.init()
        
        self.id = id
        self.icon = icon
        self.isAvailable = isAvailable
    }
    
    func toTripIconEntityDao() -> TripIconEntity.DAO {
        return TripIconEntity.DAO(id: self.id, iconId: self.icon)
    }
}
