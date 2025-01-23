//
//  DataClass.swift
//  Footprint
//
//  Created by sandy on 2022/11/04.
//


import Foundation
import Photos
import RealmSwift
import Realm
import UIKit

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
    
    // V2
    @Persisted var newID: String
    @Persisted var categoryId: String
    @Persisted var memberIds: List<String>

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
        self.newID = UUID().uuidString
        self.categoryId = ""
        self.memberIds = List()
    }
}

extension FootPrint {
    func toFootprintV1() -> FootprintV1 {
        FootprintV1(
            id: self.id.stringValue,
            title: self.title,
            content: self.content,
            images: self.images.map({ String($0) }),
            createdAt: self.createdAt,
            latitude: self.latitude,
            longitude: self.longitude,
            tag: self.tag,
            peopleWithIds: self.peopleWithIds.map({ String($0) }),
            address: self.address ?? "",
            isStar: self.isStar
        )
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
    
    // V2
    @Persisted var newID: String
    @Persisted var footprintIDs: List<String>
    
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
        
        self.newID = UUID().uuidString
        self.footprintIDs = List()
    }
}

extension Travel {
    func toTripV1() -> TripV1 {
        TripV1(
            id: self.id.stringValue,
            footprintIds: self.footprints.map({ String($0.id.stringValue) }),
            title: self.title,
            intro: self.intro,
            createdAt: self.createdAt,
            color: self.color,
            fromDate: self.fromDate,
            toDate: self.toDate,
            isStar: self.isStar
        )
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
    
    // V2
    @Persisted var newID: String
    @Persisted var newColor: Int
    @Persisted var newIcon: String
    
    convenience init(tag: Int, name: String, pinType: PinType, pinColor: PinColor) {
        self.init()
        self.tag = tag
        self.name = name
        self.pinType = pinType.rawValue
        self.pinColor = pinColor.rawValue
        self.newID = UUID().uuidString
        self.newColor = 0
        self.newIcon = ""
    }
}

extension Category {
    func toCategoryV1() -> CategoryV1 {
        CategoryV1(
            tag: self.tag,
            name: self.name,
            pinType: self.pinType,
            pinColor: self.pinColor
        )
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
    
    // V2
    @Persisted var newID: String
    
    convenience init(id: Int, name: String, image: String, intro: String) {
        self.init()
        self.id = id
        self.name = name
        self.image = image
        self.intro = intro
        self.newID = UUID().uuidString
    }
}


extension PeopleWith {
    func toMemberV1() -> MemberV1 {
        MemberV1(id: self.id, name: self.name, image: self.image, intro: self.intro)
    }
}
