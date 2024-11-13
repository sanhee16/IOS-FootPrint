//
//  TripV2.swift
//  Footprint
//
//  Created by sandy on 11/12/24.
//

import RealmSwift

class TripV2: Object {
    @Persisted(primaryKey: true) var id: String
    @Persisted var idx: Int
    @Persisted var title: String
    @Persisted var content: String
    @Persisted var iconId: String
    @Persisted var footprintIds: List<String>
    @Persisted var startAt: Int
    @Persisted var endAt: Int
    @Persisted var createdAt: Int
    
    convenience init(id: String, idx: Int, title: String, content: String, iconId: String, footprintIds: List<String>, startAt: Int, endAt: Int, createdAt: Int) {
        self.init()
        
        self.id = id
        self.idx = idx
        self.title = title
        self.content = content
        self.iconId = iconId
        self.footprintIds = footprintIds
        self.startAt = startAt
        self.endAt = endAt
        self.createdAt = createdAt
    }
    
    func toTripEntity(_ icon: TripIcon, notes: [Note]) -> TripEntity {
        return TripEntity(
            id: self.id,
            title: self.title,
            content: self.content,
            icon: icon,
            footprints: notes,
            startAt: self.startAt,
            endAt: self.endAt
        )
    }
}
