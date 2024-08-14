//
//  SplashVM2.swift
//  Footprint
//
//  Created by sandy on 8/8/24.
//

import Foundation
import CoreLocation
import GoogleMaps

class SplashVM2: BaseViewModel {
    @Published var isShowMain: Bool = false
    var myLocation: Location? = nil
    
    override init() {
        super.init()
        
        Task {
            await self.createMapView()
        }
    }

    @MainActor
    private func createMapView() {
        self.getCurrentLocation()
        let zoom: Float = 17.8
        let latitude: Double = self.myLocation?.latitude ?? 37.574187
        let longitude: Double = self.myLocation?.longitude ?? 126.976882
        
        let camera = GMSCameraPosition.camera(withLatitude: latitude, longitude: longitude, zoom: zoom)
        let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        
        // 지도 setting
        // https://developers.google.com/maps/documentation/ios-sdk/controls
        mapView.isIndoorEnabled = false
        mapView.isMyLocationEnabled = true
        mapView.isBuildingsEnabled = false
        mapView.settings.compassButton = true
        mapView.settings.myLocationButton = true
        
        C.mapView = mapView
        
        self.isShowMain = true
    }
    
    private func getCurrentLocation() {
        if let coor = CLLocationManager().location?.coordinate {
            let latitude = coor.latitude
            let longitude = coor.longitude
            self.myLocation = Location(latitude: latitude, longitude: longitude)
        }
    }
}
