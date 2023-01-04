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
        
        //지도 setting
        mapView.isIndoorEnabled = false
        mapView.isMyLocationEnabled = true
        mapView.isBuildingsEnabled = false
        
        mapView.delegate = context.coordinator
        
        vm.initMapView(mapView)
        vm.loadAllMarkers()
        
        return mapView
    }
    
    func updateUIView(_ mapView: GMSMapView, context: Context) {
        let latitude: Double = $vm.myLocation.wrappedValue?.latitude ?? 35.7532
        let longitude: Double = $vm.myLocation.wrappedValue?.longitude ?? 127.15
        mapView.animate(toLocation: CLLocationCoordinate2D(latitude: latitude, longitude: longitude))
    }
    
    class Coordinator: NSObject, GMSMapViewDelegate {
        @ObservedObject var vm: VM
        let owner: GoogleMapView
        
        init(owner: GoogleMapView, vm: VM) {
            self.owner = owner
            self.vm = vm
        }
        
        func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
            print("[GoogleMapView] on tap marker")
            print("marker info: \(marker)")
            vm.onTapMarker(Location(latitude: marker.position.latitude, longitude: marker.position.longitude))
            return true
        }
        
        func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
            print("[GoogleMapView] success on tap mapview")
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
