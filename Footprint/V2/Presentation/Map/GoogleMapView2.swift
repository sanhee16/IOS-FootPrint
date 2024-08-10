//
//  GoogleMapView2.swift
//  Footprint
//
//  Created by sandy on 8/10/24.
//

import SwiftUI
import SDSwiftUIPack
import MapKit
import GoogleMaps

struct GoogleMapView2: UIViewRepresentable {
    var vm: MapVM2
    
    init(vm: MapVM2) {
        self.vm = vm
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(vm: self.vm)
    }
    
    private let zoom: Float = 17.8
    
    func makeUIView(context: Self.Context) -> GMSMapView {
        guard let mapView = C.mapView else {
            let mapView = vm.createMapView()
            mapView.delegate = context.coordinator
            C.mapView = mapView
            vm.loadAllMarkers()
            return mapView
        }
        
        mapView.delegate = context.coordinator
        
        vm.loadAllMarkers()
        
        return mapView
    }
    
    func updateUIView(_ mapView: GMSMapView, context: Context) {
        
    }
    
    class Coordinator: NSObject, GMSMapViewDelegate {
        var vm: MapVM2

        init(vm: MapVM2) {
            print("[SD] Coordinator init")
            self.vm = vm
        }
        
        func mapView(_ mapView: GMSMapView, didTapPOIWithPlaceID placeID: String, name: String, location: CLLocationCoordinate2D) {
            print("[SD] didTapPOIWithPlaceID")
            // 클릭하면 장소의 이름과 placeId가 나옴!
            var newName = name
            if let newLineIdx = name.firstIndex(of: "\n") {
                newName.removeSubrange(newLineIdx...)
            }
            vm.removeCurrentMarker()
            vm.drawCurrentMarker(Location(latitude: location.latitude, longitude: location.longitude))
            vm.addNewMarker(Location(latitude: location.latitude, longitude: location.longitude), name: newName, placeId: placeID)
        }
        
        func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
            print("[SD] didTap")
            let location = Location(latitude: marker.position.latitude, longitude: marker.position.longitude)
            if vm.currentTapMarker == marker {
                vm.addNewMarker(location)
            } else {
                vm.removeCurrentMarker()
                vm.onTapMarker(location)
            }
            return true
        }
        
        func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
            vm.removeCurrentMarker()
            vm.drawCurrentMarker(Location(latitude: coordinate.latitude, longitude: coordinate.longitude))
            vm.addNewMarker(Location(latitude: coordinate.latitude, longitude: coordinate.longitude))
        }
        
        func mapView(_ mapView: GMSMapView, didTapMyLocation location: CLLocationCoordinate2D) {
            print("[SD] didTapMyLocation: - \(location)")
        }
        
        func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {

        }
    }
}
