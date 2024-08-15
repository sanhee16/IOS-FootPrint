//
//  FPMapManager.swift
//  Footprint
//
//  Created by sandy on 8/15/24.
//

import Foundation
import MapKit
import GoogleMaps
import GooglePlaces
import SwiftUI
import Contacts

@MainActor
class FPMapManager: NSObject, ObservableObject {
    static let shared = FPMapManager()
    private var myLocation: Location? = nil
    
    private var locationManager: CLLocationManager
    @Published var centerPosition: CLLocationCoordinate2D?
    @Published var centerMarkerStatus: MarkerStatus = .stable
    @Published var centerAddress: String = ""
    
    @Published var mapView: GMSMapView
    
    private override init() {
        self.mapView = GMSMapView.init()
        
        self.centerPosition = nil
        self.locationManager = CLLocationManager()
        self.locationManager.allowsBackgroundLocationUpdates = false
        
        super.init()
        mapView.delegate = self
        
        self.settingMapView()
    }
    
    @MainActor
    func updateMapView() {
        self.mapView = GMSMapView.init()
    }
    
    @MainActor
    func moveToCurrentLocation() {
        self.getCurrentLocation()
        
        let zoom: Float = 17.8
        let latitude: Double = self.myLocation?.latitude ?? 37.574187
        let longitude: Double = self.myLocation?.longitude ?? 126.976882
        
        let camera = GMSCameraPosition.camera(withLatitude: latitude, longitude: longitude, zoom: zoom)
        mapView.camera = camera
    }
    
    @MainActor
    func settingMapView() {
        self.moveToCurrentLocation()
        
        // 지도 setting
        mapView.mapType = .normal
        mapView.isIndoorEnabled = false
        mapView.isBuildingsEnabled = false
        mapView.isMyLocationEnabled = true
        
        C.mapView = mapView
    }
    
    private func getCurrentLocation() {
        if let coor = CLLocationManager().location?.coordinate {
            let latitude = coor.latitude
            let longitude = coor.longitude
            self.myLocation = Location(latitude: latitude, longitude: longitude)
        }
    }
    
    private func changeStateSelectedMarker(_ isDrag: Bool, target: CLLocationCoordinate2D?) {
        self.centerMarkerStatus = isDrag ? .move : .stable
        self.centerPosition = target
        
        guard let target = target else { return }
        
        let location = CLLocation(latitude: target.latitude, longitude: target.longitude)
        let geocoder = CLGeocoder()
        let locale = Locale(identifier: "Ko-kr")
        
        geocoder.reverseGeocodeLocation(location, preferredLocale: locale) { [weak self] placemarks, _ in
            guard let placemarks = placemarks,
                  let address = placemarks.last
            else { return }
            
            if let postalAddress = address.postalAddress {
                let formatter = CNPostalAddressFormatter()
                let addressString = formatter.string(from: postalAddress)
                
                print("addressString: \(addressString)")
                var result: String = ""
                addressString.split(separator: "\n").forEach { value in
                    result.append(contentsOf: "\(value) ")
                }
                self?.centerAddress = result
                print("result: \(result)")
            }
        }
    }
}

extension FPMapManager: GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        return true
    }
    
    func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
        self.changeStateSelectedMarker(true, target: nil)
    }

    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        self.changeStateSelectedMarker(false, target: position.target)
    }
}
