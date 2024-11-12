//
//  Note.swift
//  Footprint
//
//  Created by sandy on 8/23/24.
//

import Foundation
import SwiftUI

public struct Note {
    var id: String
    var title: String
    var content: String
    var createdAt: Int
    var imageUrls: [String] // path
    var categoryId: String
    var peopleWithIds: [String]
    var isStar: Bool
    var latitude: Double
    var longitude: Double
    var address: String
    var category: CategoryEntity?
    var peopleWith: [MemberEntity]?
    
    init(
        id: String = UUID().uuidString,
        title: String,
        content: String,
        createdAt: Int,
        imageUrls: [String],
        categoryId: String,
        peopleWithIds: [String],
        isStar: Bool,
        latitude: Double,
        longitude: Double,
        address: String
    ) {
        self.id = id
        self.title = title
        self.content = content
        self.createdAt = createdAt
        self.imageUrls = imageUrls
        self.categoryId = categoryId
        self.peopleWithIds = peopleWithIds
        self.isStar = isStar
        self.latitude = latitude
        self.longitude = longitude
        self.address = address
        self.category = nil
        self.peopleWith = nil
    }
}
