//
//  GetLocationPermissionUseCase.swift
//  Footprint
//
//  Created by sandy on 11/25/24.
//

import CoreLocation

class GetLocationPermissionUseCase {
    
    func execute() -> Bool {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedAlways, .authorizedWhenInUse:
            return true
        default:
            return false
        }
    }
}
