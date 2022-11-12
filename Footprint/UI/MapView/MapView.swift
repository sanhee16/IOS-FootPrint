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
    typealias VM = MapViewModel
    @ObservedObject var vm: VM
    
    init(_ coordinator: AppCoordinator, location: Location) {
        print("init")
        self.vm = MapViewModel(coordinator, location: location)
    }
    
    func makeUIView(context: Context) -> NMFNaverMapView {
        let view = NMFNaverMapView()
        print("makeUIVIew")
        view.showZoomControls = false
        view.mapView.zoomLevel = 17
        view.mapView.mapType = .basic
        view.mapView.touchDelegate = context.coordinator
        view.mapView.positionMode = .direction
        
        // 사용자의 현재 위치
        //        let locationOverlay = view.mapView.locationOverlay
        //        locationOverlay.hidden = true
        
        // delegate채택
        view.mapView.touchDelegate = context.coordinator
        view.mapView.addCameraDelegate(delegate: context.coordinator)
        view.mapView.addOptionDelegate(delegate: context.coordinator)
        
        let cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(lat: $vm.location.wrappedValue.latitude, lng: $vm.location.wrappedValue.longitude))
        view.mapView.moveCamera(cameraUpdate)
        
        vm.loadAllMarkers(view.mapView)
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
            vm.addNewMarker(mapView, location: loc)
//            addMarker(mapView, location: loc)
//            vm.addNewMarker {[weak self] in
//                print("add New Marker cancel callback")
//                self?.removeMarker(mapView, location: loc)
//            }
        }
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(vm: self.vm)
    }
}
