//
//  NoteData.swift
//  Footprint
//
//  Created by sandy on 8/22/24.
//

import Foundation
import RealmSwift

class NoteData: Object {
    @Persisted(primaryKey: true) var id: String
    @Persisted var title: String
    @Persisted var content: String
    @Persisted var images: List<String>
    @Persisted var createdAt: Int
    @Persisted var latitude: Double
    @Persisted var longitude: Double
    @Persisted var tag: Int // categoryTag
    @Persisted var peopleWithIds: List<Int> = List()
    @Persisted var placeId: String?
    @Persisted var address: String?
    @Persisted var isStar: Bool
    
    convenience init(title: String, content: String, images: List<String>, latitude: Double, longitude: Double, tag: Int, peopleWithIds: List<Int>, placeId: String? = nil, address: String? = nil, isStar: Bool) {
        self.init()
        
        self.id = UUID().uuidString
        self.title = title
        self.content = content
        self.images = images
        self.createdAt = Int(Date().timeIntervalSince1970)
        self.latitude = latitude
        self.longitude = longitude
        self.tag = tag
        self.peopleWithIds = peopleWithIds
        self.placeId = placeId
        self.address = address
        self.isStar = isStar
    }
}
