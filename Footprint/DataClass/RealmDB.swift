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

class R {
    static let realm: Realm = try! Realm()
}

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
    @Persisted var placeId: String?
    @Persisted var address: String?
    @Persisted var isStar: Bool
    @Persisted var deleteTime: Int

    convenience init(title: String, content: String, images: List<String>, createdAt: Date, latitude: Double, longitude: Double, tag: Int, peopleWithIds: List<Int>, placeId: String? = nil, address: String?, isStar: Bool, deleteTime: Int = 0) {
        self.init()
        self.title = title
        self.content = content
        self.images = images
        self.createdAt = Int(createdAt.timeIntervalSince1970)
        self.latitude = latitude
        self.longitude = longitude
        self.tag = tag
        self.peopleWithIds = peopleWithIds
        self.placeId = placeId
        self.address = address
        self.isStar = isStar
        self.deleteTime = deleteTime
    }
}

class Travel: Object {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var footprints: List<FootPrint>
    @Persisted var title: String
    @Persisted var intro: String
    @Persisted var createdAt: Int
    @Persisted var color: String
    @Persisted var fromDate: Int
    @Persisted var toDate: Int
    @Persisted var isStar: Bool
    @Persisted var deleteTime: Int
    
    convenience init(id: ObjectId? = nil, footprints: List<FootPrint>, title: String, intro: String, color: String, fromDate: Date, toDate: Date, isStar: Bool, deleteTime: Int = 0) {
        self.init()
        if let id = id {
            self.id = id
        }
        self.footprints = footprints
        self.title = title
        self.intro = intro
        self.color = color
        self.createdAt = Int(Date().timeIntervalSince1970)
        self.fromDate = Int(fromDate.timeIntervalSince1970)
        self.toDate = Int(toDate.timeIntervalSince1970)
        self.isStar = isStar
        self.deleteTime = deleteTime
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


public class PeopleWith: Object {
    public static func == (lhs: PeopleWith, rhs: PeopleWith) -> Bool {
        return lhs.id == rhs.id
    }
    
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

