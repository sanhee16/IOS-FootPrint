//
//  TripListEntity.swift
//  Footprint
//
//  Created by sandy on 11/12/24.
//

struct TripListEntity {
    let id: String
    let title: String
    let content: String
    var icon: TripIcon
    var footprints: [Note]
    var startAt: Int
    var endAt: Int
}
