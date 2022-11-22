//
//  MapViewModel.swift
//  Footprint
//
//  Created by sandy on 2022/11/10.
//

import Foundation
import MapKit
import NMapsMap
import RealmSwift

class MapViewModel: BaseViewModel {
    @Published var location: Location
    @Published var markerList: [MarkerItem] = []
    private let realm: Realm
    
    
    init(_ coordinator: AppCoordinator, location: Location) {
        self.location = location
        self.realm = try! Realm()
        super.init(coordinator)
    }
    
    func onAppear() {
        
    }
    
    func loadAllMarkers(_ mapView: NMFMapView) {
        self.startProgress()
        for item in self.markerList {
            removeMarker(mapView, marker: item.marker)
        }
        self.markerList.removeAll()
        let footPrints = realm.objects(FootPrint.self)
        for footPrint in footPrints {
            let copy = MarkerItem(marker: drawMarker(mapView, location: Location(latitude: footPrint.latitude, longitude: footPrint.longitude), pinType: PinType(rawValue: footPrint.pinType) ?? .pin0), footPrint: footPrint)
            markerList.append(copy)
        }
        self.stopProgress()
    }

    
    func removeMarker(_ mapView: NMFMapView, marker: NMFMarker) {
        marker.mapView = nil
    }
    
    func onClose() {
        self.dismiss()
    }
    
    func onTapMarker(_ location: Location) {
        print("on tap marker")
        self.coordinator?.presentShowFootPrintView(location)
//        self.coordinator?.presentAddFootprintView(location: self.location)
    }
    
    func addNewMarker(_ mapView: NMFMapView, location: Location) {
        
        // 마커 생성하기
        let marker = NMFMarker()
        marker.position = NMGLatLng(lat: location.latitude, lng: location.longitude)
        
        // 마커 그룹
//        marker.tag = IntValue
        
        // marker 사이즈 지정
        marker.width = 26
        marker.height = 36
        
        // marker 색상 입히기
        marker.iconImage = NMF_MARKER_IMAGE_BLACK
        marker.iconTintColor = PinType.pin0.pinUIColor //TODO: change
        
        marker.mapView = mapView
        self.alert(.yesOrNo, title: "현재 위치에 마커를 추가하시겠습니까?") {[weak self] res in
            guard let self = self else { return }
            if res {
                print("add New Marker ok")
                marker.mapView = nil
                self.coordinator?.presentAddFootprintView(location: location) {[weak self] in
                    guard let self = self else { return }
                    self.loadAllMarkers(mapView)
                }
            } else {
                print("add New Marker cancel")
                marker.mapView = nil
            }
        }
    }
    
    func drawMarker(_ mapView: NMFMapView, location: Location, pinType: PinType) -> NMFMarker {
        // 마커 생성하기
        let marker = NMFMarker()
        marker.position = NMGLatLng(lat: location.latitude, lng: location.longitude)
        
        // marker 사이즈 지정
        marker.width = 30
        marker.height = 29
        
        // marker 색상 입히기
        marker.iconImage = NMFOverlayImage(name: pinType.pinName)
//        marker.iconImage = NMF_MARKER_IMAGE_BLACK
        marker.iconTintColor = pinType.pinUIColor //TODO: change
        
        marker.mapView = mapView
        
        marker.touchHandler = {[weak self] (overlay) in
            self?.onTapMarker(location)
            return true
        }
        return marker
    }
}
