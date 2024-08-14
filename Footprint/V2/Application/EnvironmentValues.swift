//
//  EnvironmentValues.swift
//  Footprint
//
//  Created by sandy on 8/13/24.
//

import Foundation
import SwiftUI
import CoreLocation
import GoogleMaps

private struct CenterLocation: EnvironmentKey {
    static let defaultValue = CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0)
}

private struct IsShowMain: EnvironmentKey {
    static let defaultValue = false
}

extension EnvironmentValues {
    var centerLocation: CLLocationCoordinate2D {
        get { self[CenterLocation.self] }
        set { self[CenterLocation.self] = newValue }
    }
    
    var isShowMain: Bool {
        get { self[IsShowMain.self] }
        set { self[IsShowMain.self] = newValue }
    }
}

