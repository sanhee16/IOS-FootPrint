//
//  V1DataModels.swift
//  Footprint
//
//  Created by sandy on 1/21/25.
//

import Foundation

struct CategoryV1 {
    var tag: Int
    var name: String
    var pinType: Int
    var pinColor: Int
}

struct MemberV1 {
    var id: Int
    var name: String
    var image: String
    var intro: String
}


struct TripV1 {
    var id: String
    var footprintIds: [String]
    var title: String
    var intro: String
    var createdAt: Int
    var color: String
    var fromDate: Int
    var toDate: Int
    var isStar: Bool
}


struct FootprintV1 {
    var id: String
    var title: String
    var content: String
    var images: [String]
    var createdAt: Int
    var latitude: Double
    var longitude: Double
    var tag: Int
    var peopleWithIds: [String]
    var address: String
    var isStar: Bool
}
