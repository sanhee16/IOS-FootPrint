//
//  V1DataModels.swift
//  Footprint
//
//  Created by sandy on 1/21/25.
//

import Foundation

struct CategoryV1 {
    var id: String
    var name: String
    var icon: CategoryIcon
    var color: CategoryColor
}

struct MemberV1 {
    var id: String
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
    var categoryId: String
    var memberIds: [String]
    var address: String
    var isStar: Bool
}
