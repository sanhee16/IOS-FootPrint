//
//  NoteEntity.swift
//  Footprint
//
//  Created by sandy on 11/20/24.
//

public struct NoteEntity: Equatable, Hashable {
    var id: String
    var title: String
    var content: String
    var createdAt: Int
    var imageUrls: [String] // path
    var isStar: Bool
    var latitude: Double
    var longitude: Double
    var address: String
    var category: CategoryEntity
    var members: [MemberEntity]
    
    init(
        id: String,
        title: String,
        content: String,
        createdAt: Int,
        imageUrls: [String],
        isStar: Bool,
        latitude: Double,
        longitude: Double,
        address: String,
        category: CategoryEntity,
        members: [MemberEntity]
    ) {
        self.id = id
        self.title = title
        self.content = content
        self.createdAt = createdAt
        self.imageUrls = imageUrls
        self.isStar = isStar
        self.latitude = latitude
        self.longitude = longitude
        self.address = address
        self.category = category
        self.members = members
    }
}

extension NoteEntity {
    struct DAO {
        var id: String
        var title: String
        var content: String
        var createdAt: Int
        var imageUrls: [String]
        var categoryId: String
        var memberIds: [String]
        var isStar: Bool
        var latitude: Double
        var longitude: Double
        var address: String
    }
}
