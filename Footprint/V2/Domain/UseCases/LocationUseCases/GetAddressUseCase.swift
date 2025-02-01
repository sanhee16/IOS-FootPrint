//
//  GetAddressUseCase.swift
//  Footprint
//
//  Created by sandy on 2/1/25.
//

import Foundation
import CoreLocation
import Contacts

class GetAddressUseCase {
    
    func execute(_ location: CLLocation) async -> String {
        return await withCheckedContinuation { continuation in
            let geocoder = CLGeocoder()
            let locale = Locale(identifier: UserLocale.identifier()) //TODO: 언어 바꾸기!
            
            geocoder.reverseGeocodeLocation(location, preferredLocale: locale) { placemarks, _ in
                guard let placemarks = placemarks, let address = placemarks.last else {
                    continuation.resume(returning: "")
                    return
                }
                
                if let postalAddress = address.postalAddress {
                    let formatter = CNPostalAddressFormatter()
                    let addressString = formatter.string(from: postalAddress)
                    
                    var result: String = ""
                    addressString.split(separator: "\n").forEach { value in
                        result.append(contentsOf: "\(value) ")
                    }
                    continuation.resume(returning: result)
                }
            }
        }
    }
}
