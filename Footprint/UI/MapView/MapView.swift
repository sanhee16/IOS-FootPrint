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


struct MapView: UIViewRepresentable {
    @ObservedObject var viewModel = MapViewModel()
    @State var latitude: Double
    @State var longitude: Double
    
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
        
        let cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(lat: latitude, lng: longitude))
        view.mapView.moveCamera(cameraUpdate)
        return view
    }
    
    func updateUIView(_ uiView: NMFNaverMapView, context: Context) {}
    
    
    class Coordinator: NSObject, NMFMapViewTouchDelegate, NMFMapViewCameraDelegate, NMFMapViewOptionDelegate {
        @ObservedObject var viewModel: MapViewModel
        var cancellable = Set<AnyCancellable>()
        
        init(viewModel: MapViewModel) {
            self.viewModel = viewModel
        }
        
        func mapView(_ mapView: NMFMapView, didTapMap latlng: NMGLatLng, point: CGPoint) {
            print("지도 탭했음 : \(latlng.lat) | \(latlng.lng)")
            addMarker(mapView, location: Location(latitude: latlng.lat, longitude: latlng.lng), pinType: .pin3)
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
            //            marker.touchHandler = { (overlay) -> Bool in
            //                print("marker touch")
            //            }
        }
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(viewModel: self.viewModel)
    }
    
    //    func addMarker(_ mapView: NMFNaverMapView, place: Place) {
    //        // 마커 생성하기
    //        let marker = placeToMarker(mapView, place: place)
    //
    //        // 마커 userInfo에 placeId 저장하기
    //        marker.userInfo = ["placeId": place.placeId]
    //        marker.mapView = mapView.mapView
    //
    //        // 터치 이벤트 설정
    //        marker.touchHandler = { (overlay) -> Bool in
    //            print("마커 터치")
    //            print(overlay.userInfo["placeId"] ?? "placeId없음")
    //            viewModel.place = place
    //            viewModel.placeId = overlay.userInfo["placeId"] as! String
    //            viewModel.isBottomPageUp = true
    //            return true
    //        }
    //    }
}
