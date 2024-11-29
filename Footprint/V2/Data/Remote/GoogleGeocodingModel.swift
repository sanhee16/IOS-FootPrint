//
//  GoogleGeocodingModel.swift
//  Footprint
//
//  Created by sandy on 11/26/24.
//

import Foundation

struct GoogleGeocodingModel: Codable, Equatable {
    let geometry: Geometry
    let placeId: String
    
    enum CodingKeys: String, CodingKey {
        case geometry = "geometry"
        case placeId = "place_id"
    }
}
