//
//  C.swift
//  Footprint
//
//  Created by sandy on 2022/11/12.
//

import Foundation
import GoogleMaps
import GooglePlaces
import CoreLocation

enum DevMode {
    case release
    case develop
}

public class C {
    // https://maps.googleapis.com/maps/api/geocode/json?place_id=\()&key=\(Bundle.main.googleApiKey)
    static var GEOCODING_HOST: String = "https://maps.googleapis.com/maps/api/geocode/"
    static var permissionLocation: Bool = false
    static var mapView: GMSMapView? = nil
    static var isDebugMode: Bool = false
    static var isFirstAppStart: Bool = true
    
    static var devMode: DevMode = .release
    static var temporaryNote: TemporaryNote? = nil
}

