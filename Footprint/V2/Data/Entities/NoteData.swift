//
//  NoteData.swift
//  Footprint
//
//  Created by sandy on 8/22/24.
//

import Foundation
import RealmSwift
import UIKit

class NoteData: Object {
    @Persisted(primaryKey: true) var id: String
    @Persisted var title: String
    @Persisted var content: String
    @Persisted var imageUrls: List<String>
    @Persisted var createdAt: Int
    @Persisted var latitude: Double
    @Persisted var longitude: Double
    @Persisted var peopleWithIds: List<String> = List()
    @Persisted var categoryId: String
    @Persisted var address: String?
    @Persisted var isStar: Bool

    
    convenience init(
        id: String? = UUID().uuidString,
        title: String,
        content: String,
        imageUrls: List<String>,
        createdAt: Int,
        latitude: Double,
        longitude: Double,
        peopleWithIds: List<String>,
        categoryId: String,
        address: String? = nil,
        isStar: Bool
    ) {
        self.init()
        
        self.id = id ?? UUID().uuidString
        self.title = title
        self.content = content
        self.imageUrls = imageUrls
        self.createdAt = createdAt
        self.latitude = latitude
        self.longitude = longitude
        self.peopleWithIds = peopleWithIds
        self.categoryId = categoryId
        self.address = address
        self.isStar = isStar
    }
    
    func mapper() -> Note {
        return Note(
            title: self.title,
            content: self.content,
            createdAt: self.createdAt,
            imageUrls: Array(self.imageUrls),
            categoryId: categoryId,
            peopleWithIds: Array(self.peopleWithIds),
            isStar: self.isStar,
            latitude: self.latitude,
            longitude: self.longitude,
            address: self.address ?? ""
        )
    }
}
