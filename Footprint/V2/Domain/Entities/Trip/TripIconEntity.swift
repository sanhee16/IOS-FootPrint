//
//  TripIconEntity.swift
//  Footprint
//
//  Created by sandy on 11/12/24.
//

struct TripIconEntity: Equatable, Hashable {
    let id: String
    let icon: TripIcon
    var isSelected: Bool
}

extension TripIconEntity {
    struct DAO {
        let id: String
        let iconId: String
    }
}
