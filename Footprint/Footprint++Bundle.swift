//
//  Footprint++Bundle.swift
//  Footprint
//
//  Created by Studio-SJ on 2023/01/04.
//

import Foundation

// Use Plist for get API_KEY
// https://nareunhagae.tistory.com/44
extension Bundle {
    var googleApiKey: String {
        get {
            // 1
            guard let filePath = Bundle.main.path(forResource: "ApiInfo", ofType: "plist") else {
                fatalError("Couldn't find file 'ApiInfo.plist'.")
            }
            // 2
            let plist = NSDictionary(contentsOfFile: filePath)
            guard let value = plist?.object(forKey: "GOOGLE_API_KEY") as? String else {
                fatalError("Couldn't find key 'GOOGLE_API_KEY' in 'ApiInfo.plist'.")
            }
            return value
        }
    }
    var geocodingApiKey: String {
        get {
            // 1
            guard let filePath = Bundle.main.path(forResource: "ApiInfo", ofType: "plist") else {
                fatalError("Couldn't find file 'ApiInfo.plist'.")
            }
            // 2
            let plist = NSDictionary(contentsOfFile: filePath)
            guard let value = plist?.object(forKey: "GEOCODING_API_KEY") as? String else {
                fatalError("Couldn't find key 'GEOCODING_API_KEY' in 'ApiInfo.plist'.")
            }
            return value
        }
    }

}

