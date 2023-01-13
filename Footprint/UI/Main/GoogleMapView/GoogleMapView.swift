//
//  GoogleMapView.swift
//  Footprint
//
//  Created by Studio-SJ on 2023/01/04.
//

import SwiftUI
import MapKit
import GoogleMaps
/*
 지도: https://developers.google.com/maps/documentation/ios-sdk/configure-map?hl=ko
 places: https://developers.google.com/maps/documentation/places/ios-sdk/current-place?hl=ko
 */

struct GoogleMapView: UIViewRepresentable {
    
    typealias VM = MainViewModel
    @ObservedObject var vm: VM
    
    init(_ coordinator: AppCoordinator, vm: MainViewModel) {
        self.vm = vm
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(owner: self, vm: self.vm)
    }
    
    private let zoom: Float = 17.5
    
    func makeUIView(context: Self.Context) -> GMSMapView {
        let latitude: Double = $vm.myLocation.wrappedValue?.latitude ?? 35.7532
        let longitude: Double = $vm.myLocation.wrappedValue?.longitude ?? 127.15
        print("longitude: \(longitude) / latitude: \(latitude)")
        let camera = GMSCameraPosition.camera(withLatitude: latitude, longitude: longitude, zoom: zoom)
        let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        
        // 지도 setting
        // https://developers.google.com/maps/documentation/ios-sdk/controls
        mapView.isIndoorEnabled = false
        mapView.isMyLocationEnabled = true
        mapView.isBuildingsEnabled = false
        mapView.settings.compassButton = true
        mapView.settings.myLocationButton = true
        
        mapView.delegate = context.coordinator
        
        vm.initMapView(mapView)
        vm.loadAllMarkers()
        
        return mapView
    }
    
    func updateUIView(_ mapView: GMSMapView, context: Context) {
        
    }
    
    class Coordinator: NSObject, GMSMapViewDelegate {
        @ObservedObject var vm: VM
        let owner: GoogleMapView
        
        init(owner: GoogleMapView, vm: VM) {
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
            print("[GoogleMapView] on tap marker")
            print("marker info: \(marker)")
            vm.removeCurrentMarker()
            vm.onTapMarker(Location(latitude: marker.position.latitude, longitude: marker.position.longitude))
            return true
        }
        
        func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
            print("[GoogleMapView] success on tap mapview")
            vm.removeCurrentMarker()
            vm.drawCurrentMarker(Location(latitude: coordinate.latitude, longitude: coordinate.longitude))
            vm.addNewMarker(Location(latitude: coordinate.latitude, longitude: coordinate.longitude))
        }
        
        func mapView(_ mapView: GMSMapView, didTapMyLocation location: CLLocationCoordinate2D) {
            //            print("[GoogleMapView] tap my loacation")
        }
        
        func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
            //            print("[GoogleMapView] willMove")
        }
    }
}
