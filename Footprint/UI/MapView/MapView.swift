//
//  MapView.swift
//  Footprint
//
//  Created by sandy on 2022/11/10.
//

import SwiftUI
import MapKit
import NMapsMap
import Combine
import simd


struct MapView: UIViewRepresentable {
    typealias VM = MainViewModel
    @ObservedObject var vm: VM
    
    init(_ coordinator: AppCoordinator, location: Location, vm: MainViewModel) {
        self.vm = vm
    }
    
    func makeUIView(context: Context) -> NMFNaverMapView {
        let view = NMFNaverMapView()
        print("makeUIVIew")
        view.showZoomControls = false
        view.mapView.zoomLevel = 17
        view.mapView.mapType = .basic
        view.mapView.touchDelegate = context.coordinator
        view.mapView.positionMode = .direction
        view.showLocationButton = true
        
        // 사용자의 현재 위치
        //        let locationOverlay = view.mapView.locationOverlay
        //        locationOverlay.hidden = true
        
        // delegate채택
        view.mapView.touchDelegate = context.coordinator
        view.mapView.addCameraDelegate(delegate: context.coordinator)
        view.mapView.addOptionDelegate(delegate: context.coordinator)
        if let myLocation = $vm.myLocation.wrappedValue {
            let cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(lat: myLocation.latitude, lng: myLocation.longitude))
            view.mapView.moveCamera(cameraUpdate)
        }
//        vm.initMapView(view.mapView)
        vm.loadAllMarkers()
        return view
    }
    
    func updateUIView(_ uiView: NMFNaverMapView, context: Context) {
        print("updateUIView")
    }
    
    
    class Coordinator: NSObject, NMFMapViewTouchDelegate, NMFMapViewCameraDelegate, NMFMapViewOptionDelegate {
        @ObservedObject var vm: VM
        
        init(vm: VM) {
            self.vm = vm
        }
        
        func mapView(_ mapView: NMFMapView, didTapMap location: NMGLatLng, point: CGPoint) {
            print("지도 탭했음 : \(location.lat) | \(location.lng) | \(location.description)")
            print("지도 탭했음 : \(location.debugDescription)")
            print("point : \(point.debugDescription)")
            let loc: Location = Location(latitude: location.lat, longitude: location.lng)
            print("wrap : \(location.wrap())")
            vm.addNewMarker(loc)
        }
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(vm: self.vm)
    }
}
