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
    @Persisted var peopleWithIds: List<String> = List()
    @Persisted var categoryId: String
    @Persisted var address: String?
    @Persisted var isStar: Bool

    
    convenience init(id: String? = UUID().uuidString, title: String, content: String, images: List<String>, createdAt: Int, latitude: Double, longitude: Double, peopleWithIds: List<String>, categoryId: String, address: String? = nil, isStar: Bool) {
        self.init()
        
        self.id = id ?? UUID().uuidString
        self.title = title
        self.content = content
        self.images = images
        self.createdAt = createdAt
        self.latitude = latitude
        self.longitude = longitude
        self.peopleWithIds = peopleWithIds
        self.categoryId = categoryId
        self.address = address
        self.isStar = isStar
    }
}
