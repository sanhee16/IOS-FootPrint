//
//  TripIconEntity.swift
//  Footprint
//
//  Created by sandy on 11/12/24.
//

struct TripIconEntity: Equatable, Hashable {
    public static func == (lhs: TripIconEntity, rhs: TripIconEntity) -> Bool {
        return lhs.id == rhs.id
    }
    
    let id: String
    let icon: TripIcon
}

extension TripIconEntity {
    struct DAO {
        let id: String
        let iconName: String
    }
}
