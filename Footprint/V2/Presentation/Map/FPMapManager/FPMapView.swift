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
    
    func makeUIView(context: Self.Context) -> GMSMapView {
        self.mapView.delegate = context.coordinator
        return mapView
    }
    
    func updateUIView(_ mapView: GMSMapView, context: Context) {
        
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
