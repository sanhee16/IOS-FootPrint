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
public typealias Location = (latitude: Double, longitude: Double)


class FootPrint: Object {
    //TODO: location 추가해야함
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var title: String
    @Persisted var content: String
    @Persisted var images: List<String>
    @Persisted var createdAt: Int
    @Persisted var latitude: Double
    @Persisted var longitude: Double
    @Persisted var pinType: Int

    convenience init(title: String, content: String, images: List<String>, latitude: Double, longitude: Double, pinType: PinType) {
        self.init()
        self.title = title
        self.content = content
        self.images = images
        self.createdAt = Int(Date().timeIntervalSince1970)
        self.latitude = latitude
        self.longitude = longitude
        self.pinType = pinType.rawValue
    }
}

enum PinType: Int {
    case pin0
    case pin1
    case pin2
    case pin3
    case pin4
    case pin5
    case pin6
    case pin7
    case pin8
    case pin9
    
    var pinName: String {
        switch self {
        case .pin0: return "pin0"
        case .pin1: return "pin1"
        case .pin2: return "pin2"
        case .pin3: return "pin3"
        case .pin4: return "pin4"
        case .pin5: return "pin5"
        case .pin6: return "pin6"
        case .pin7: return "pin7"
        case .pin8: return "pin8"
        case .pin9: return "pin9"
        }
    }
    
    var pinColorHex: String {
        switch self {
        case .pin0: return "#000000"
        case .pin1: return "#FC1961"
        case .pin2: return "#FA5252"
        case .pin3: return "#8D5DE8"
        case .pin4: return "#CC5DE8"
        case .pin5: return "#5C7CFA"
        case .pin6: return "#339AF0"
        case .pin7: return "#20C997"
        case .pin8: return "#94D82D"
        case .pin9: return "#FCC419"
        }
    }
}
