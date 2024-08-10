//
//  GoogleMapView.swift
//  Footprint
//
//  Created by Studio-SJ on 2023/01/04.
//

import SwiftUI
import SDSwiftUIPack
import MapKit
import GoogleMaps
/*
 지도: https://developers.google.com/maps/documentation/ios-sdk/configure-map?hl=ko
 places: https://developers.google.com/maps/documentation/places/ios-sdk/current-place?hl=ko
 */

struct GoogleMapView: UIViewRepresentable {
    
    typealias VM = MapViewModel
    @ObservedObject var vm: VM
    
    init(_ coordinator: AppCoordinator, vm: MapViewModel) {
        print("[MAP VIEW] google map init")
        self.vm = vm
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(owner: self, vm: self.vm)
    }
    
    private let zoom: Float = 17.8
    
    func makeUIView(context: Self.Context) -> GMSMapView {
        print("[MAP VIEW] makeUIView")
        guard let mapView = C.mapView else {
            let mapView = vm.createMapView()
            C.mapView = mapView
            vm.loadAllMarkers()
            return mapView
        }
        
        mapView.delegate = context.coordinator
        
//        vm.initMapView(mapView)
        vm.loadAllMarkers()
        
        return mapView
    }
    
    func updateUIView(_ mapView: GMSMapView, context: Context) {
        print("[MAP VIEW] updateUIView")
        
    }
    
    class Coordinator: NSObject, GMSMapViewDelegate {
        @ObservedObject var vm: VM
        let owner: GoogleMapView
        
        init(owner: GoogleMapView, vm: VM) {
            print("[MAP VIEW] Coordinator init")
            self.owner = owner
            self.vm = vm
        }
        
        func mapView(_ mapView: GMSMapView, didTapPOIWithPlaceID placeID: String, name: String, location: CLLocationCoordinate2D) {
            print("[GoogleMapView] onTapPlace placeId: \(placeID), name: \(name)")
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
            let location = Location(latitude: marker.position.latitude, longitude: marker.position.longitude)
            if $vm.currentTapMarker.wrappedValue == marker {
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

        }
        
        func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {

        }
    }
}
