//
//  FPMapView.swift
//  Footprint
//
//  Created by sandy on 8/15/24.
//

import Foundation
import MapKit
import GoogleMaps
import GooglePlaces
import SwiftUI

struct FPMapView: UIViewRepresentable {
    @State var mapView: GMSMapView
    
    func makeUIView(context: Context) -> GMSMapView {
        return mapView
    }
    
    func updateUIView(_ uiView: GMSMapView, context: Context) {
        
    }
}

struct MainMapView: UIViewRepresentable {
    let mapView: GMSMapView
    let changeStateSelectedMarker: (Bool, CLLocationCoordinate2D?) -> ()
    var myLocation: Location? = nil
    
    init(mapView: GMSMapView, changeStateSelectedMarker: @escaping (Bool, CLLocationCoordinate2D?) -> ()) {
        self.mapView = mapView
        self.changeStateSelectedMarker = changeStateSelectedMarker
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(mapView: mapView, changeStateSelectedMarker: changeStateSelectedMarker)
    }
    
    private let zoom: Float = 17.8
    
    func makeUIView(context: Self.Context) -> GMSMapView {
        self.mapView.delegate = context.coordinator
        return mapView
    }
    
    func updateUIView(_ mapView: GMSMapView, context: Context) {
        
    }
    
    private mutating func createMapView() {
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
    }
    
    private mutating func getCurrentLocation() {
        if let coor = CLLocationManager().location?.coordinate {
            let latitude = coor.latitude
            let longitude = coor.longitude
            self.myLocation = Location(latitude: latitude, longitude: longitude)
        }
    }
    
    class Coordinator: NSObject, GMSMapViewDelegate {
        let mapView: GMSMapView
        let changeStateSelectedMarker: (Bool, CLLocationCoordinate2D?) -> ()

        init(mapView: GMSMapView, changeStateSelectedMarker: @escaping (Bool, CLLocationCoordinate2D?) -> ()) {
            self.mapView = mapView
            self.changeStateSelectedMarker = changeStateSelectedMarker
        }
        
        func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
            self.changeStateSelectedMarker(true, nil)
        }

        func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
            self.changeStateSelectedMarker(false, position.target)
        }
    }
}
