//
//  ApiResponse.swift
//  Footprint
//
//  Created by sandy on 2022/11/12.
//

import Foundation


public struct GeocodingResponse: Codable, Equatable {
    let geometry: Geometry
    let placeId: String
//    let addressComponents: String
//    let formattedAddress: Int
//    let plusCode: Int
//    let types: Double
    
    enum CodingKeys: String, CodingKey {
        case geometry = "geometry"
        case placeId = "place_id"
//        case addressComponents = "address_components"
//        case formattedAddress = "formatted_address"
//        case plusCode = "plus_code"
//        case types = "types"
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        geometry = try values.decode(Geometry.self, forKey: .geometry)
        placeId = try values.decode(String.self, forKey: .placeId)
//        addressComponents = try values.decode(String.self, forKey: .addressComponents)
//        formattedAddress = try values.decode(Int.self, forKey: .formattedAddress)
//        plusCode = try values.decode(Int.self, forKey: .plusCode)
//        types = try values.decode(Double.self, forKey: .types)
    }
}

public struct Geometry: Codable, Equatable {
    let location: GeometryLocation
    
    enum CodingKeys: String, CodingKey {
        case location
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        location = try values.decode(GeometryLocation.self, forKey: .location)
    }
}

public struct GeometryLocation: Codable, Equatable {
    let lat: Double
    let lng: Double
    
    enum CodingKeys: String, CodingKey {
        case lat
        case lng
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        lat = try values.decode(Double.self, forKey: .lat)
        lng = try values.decode(Double.self, forKey: .lng)
    }
}
