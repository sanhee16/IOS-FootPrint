//
//  DataClass.swift
//  Footprint
//
//  Created by Studio-SJ on 2022/11/04.
//


import Foundation
import Photos
import RealmSwift
import Realm


struct GalleryItem: Equatable {
    public static func == (lhs: GalleryItem, rhs: GalleryItem) -> Bool {
        return lhs.image == rhs.image
    }
    var image: UIImage
    var asset: PHAsset
    var isSelected: Bool
}

struct Location {
    var latitude: Double
    var longitude: Double
}

class FootPrint: Object {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var title: String
    @Persisted var content: String
    @Persisted var images: List<String>
    @Persisted var createdAt: Int
    @Persisted var latitude: Double
    @Persisted var longitude: Double
    @Persisted var tag: Int // categoryTag
    @Persisted var peopleWithIds: List<Int> = List()

    convenience init(title: String, content: String, images: List<String>, latitude: Double, longitude: Double, tag: Int, peopleWithIds: List<Int>) {
        self.init()
        self.title = title
        self.content = content
        self.images = images
        self.createdAt = Int(Date().timeIntervalSince1970)
        self.latitude = latitude
        self.longitude = longitude
        self.tag = tag
    }
}

class Category: Object {
    public static func == (lhs: Category, rhs: Category) -> Bool {
        return lhs.tag == rhs.tag
    }
    
    @Persisted(primaryKey: true) var tag: Int
    @Persisted var name: String
    @Persisted var pinType: Int
    @Persisted var pinColor: Int
    
    convenience init(tag: Int, name: String, pinType: PinType, pinColor: PinColor) {
        self.init()
        self.tag = tag
        self.name = name
        self.pinType = pinType.rawValue
        self.pinColor = pinColor.rawValue
    }
}


class PeopleWith: Object {
    @Persisted(primaryKey: true) var id: Int
    @Persisted var name: String
    @Persisted var image: String
    @Persisted var intro: String
    
    convenience init(id: Int, name: String, image: String, intro: String) {
        self.init()
        self.id = id
        self.name = name
        self.image = image
        self.intro = intro
    }
}

