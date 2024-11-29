//
//  GoogleGeocodingRemoteResponse.swift
//  Footprint
//
//  Created by sandy on 11/26/24.
//

import Foundation

// App정보 받아올 때 Response 정의
struct GoogleGeocodingRemoteResponse<T: Codable>: Codable {
    let status: String?
    let results: [T]?
    
    init() {
        status = nil
        results = nil
    }
}
