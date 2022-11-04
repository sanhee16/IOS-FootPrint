//
//  Util.swift
//  Footprint
//
//  Created by Studio-SJ on 2022/10/05.
//

import Foundation
import SwiftUI
import CoreLocation

enum PermissionStatus {
    case allow
    case notYet
    case notAllow
    case unknown
}

class Util {
    static func safeAreaInsets() -> UIEdgeInsets? {
        return UIApplication.shared.connectedScenes
            .filter { $0.activationState == .foregroundActive }
            .first(where: { $0 is UIWindowScene })
            .flatMap({ $0 as? UIWindowScene })?.windows
            .first(where: \.isKeyWindow)?.safeAreaInsets
    }
    
    static func safeBottom() -> CGFloat {
        return safeAreaInsets()?.bottom ?? 0
    }
    
    static func safeTop() -> CGFloat {
        return safeAreaInsets()?.top ?? 0
    }
}


func checkLocationPermission() -> PermissionStatus {
    switch CLLocationManager.authorizationStatus() {
    case .authorizedAlways, .authorizedWhenInUse: return .allow
    case .restricted, .notDetermined: return .notYet
    case .denied: return .notAllow
    default: return .unknown
    }
}
