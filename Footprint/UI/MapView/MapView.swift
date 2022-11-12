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
        self.vm = MapViewModel(coordinator, location: location)
    }
    
    func makeUIView(context: Context) -> NMFNaverMapView {
        let view = NMFNaverMapView()
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
        return view
    }
    
    func updateUIView(_ uiView: NMFNaverMapView, context: Context) {}
    
    
    class Coordinator: NSObject, NMFMapViewTouchDelegate, NMFMapViewCameraDelegate, NMFMapViewOptionDelegate {
        @ObservedObject var vm: VM
        
        init(vm: VM) {
            self.vm = vm
        }
        
        
        func mapView(_ mapView: NMFMapView, didTapMap location: NMGLatLng, point: CGPoint) {
            print("지도 탭했음 : \(location.lat) | \(location.lng) | \(location.description)")
            print("지도 탭했음 : \(location.debugDescription)")
            print("point : \(point.debugDescription)")
            
            print("wrap : \(location.wrap())")
            
            
//            addMarker(mapView, location: Location(latitude: latlng.lat, longitude: latlng.lng), pinType: .pin3)
        }
        
        func addMarker(_ mapView: NMFMapView, location: Location, pinType: PinType) {
            // 마커 생성하기
            let marker = NMFMarker()
            marker.position = NMGLatLng(lat: location.latitude, lng: location.longitude)
            
            // marker 사이즈 지정
            marker.width = 22
            marker.height = 30
            
            // marker 색상 입히기
            marker.iconImage = NMF_MARKER_IMAGE_BLACK
            marker.iconTintColor = pinType.pinUIColor
            
            
            marker.mapView = mapView
            
            // marker 터치 이벤트 설정
            marker.touchHandler = {[weak self] (overlay) in
//                print("marker touch")
                self?.vm.onTapMarker()
                return true
            }
        }
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(vm: self.vm)
    }
}
