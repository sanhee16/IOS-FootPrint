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


public typealias GalleryItem = (image: UIImage, asset: PHAsset)

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
    @Persisted var pinType: Int
    @Persisted var tag: Int

    convenience init(title: String, content: String, images: List<String>, latitude: Double, longitude: Double, pinType: PinType, tag: Int = -1) {
        self.init()
        self.title = title
        self.content = content
        self.images = images
        self.createdAt = Int(Date().timeIntervalSince1970)
        self.latitude = latitude
        self.longitude = longitude
        self.pinType = pinType.rawValue
        self.tag = tag
    }
}

class Category: Object {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var tag: Int
    @Persisted var name: String
    
    convenience init(tag: Int, name: String) {
        self.init()
        self.tag = tag
        self.name = name
    }
}
