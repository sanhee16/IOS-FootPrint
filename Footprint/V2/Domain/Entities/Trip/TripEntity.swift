//
//  TripEntity.swift
//  Footprint
//
//  Created by sandy on 11/12/24.
//

struct TripEntity {
    let id: String
    let title: String
    let content: String
    var icon: TripIcon
    var footprints: [Note]
    var startAt: Int
    var endAt: Int
}

extension TripEntity {
    struct DAO {
        let id: String
        let title: String
        let content: String
        var iconId: String
        var footprintIds: [String]
        var startAt: Int
        var endAt: Int
    }
}
