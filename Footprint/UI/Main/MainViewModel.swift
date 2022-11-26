//
//  MainViewModel.swift
//  Footprint
//
//  Created by Studio-SJ on 2022/10/05.
// realm : https://velog.io/@dlskawns96/Swift-Realm%EC%9D%98-%ED%8A%B9%EC%A7%95%EA%B3%BC-%EC%82%AC%EC%9A%A9%EB%B2%95


import Foundation
import Combine
import MapKit
import RealmSwift
import NMapsMap
import CoreLocation

struct Pin: Identifiable {
    let id = UUID()
    let footPrint: FootPrint
    let coordinate: CLLocationCoordinate2D
}

class MainViewModel: BaseViewModel {
    private var api: Api = Api.instance
    private var locationManager: CLLocationManager
    @Published var myLocation: CLLocation? = nil
    @Published var currenLocation: MKCoordinateRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0), span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
    @Published var annotations: [Pin] = []
    
    @Published var location: Location? = nil
    @Published var markerList: [MarkerItem] = []
    
    @Published var isShowCategoriesPannel: Bool = false
    @Published var categories: [Category] = []
    @Published var showingCategories: [String] = []
    private let realm: Realm
    
    
    
    override init(_ coordinator: AppCoordinator) {
        self.realm = try! Realm()
        self.locationManager = CLLocationManager()
        self.locationManager.allowsBackgroundLocationUpdates = true
        super.init(coordinator)
    }
    
    func onAppear() {
//        getSavedData()
        switch checkLocationPermission() {
        case .allow:
            getCurrentLocation()
            loadCategories()
        default:
            self.location = Location(latitude: 0.0, longitude: 0.0)
            break
        }
    }
    
    private func loadCategories() {
        print("sandy loadCategories")
        // 객체 초기화
        self.categories = []
        

        // 모든 객체 얻기
        let dbCategories = realm.objects(Category.self).sorted(byKeyPath: "tag", ascending: true)
        for i in dbCategories {
            self.categories.append(Category(tag: i.tag, name: i.name, pinType: i.pinType.pinType()))
        }
        
        self.showingCategories = Defaults.showingCategories
    }
    
    func onClickCategory(_ category: Category) {
        print("click!!!")
        if let idx = self.showingCategories.firstIndex(of: category.name) {
            self.showingCategories.remove(at: idx)
        } else {
            self.showingCategories.append(category.name)
        }
        Defaults.showingCategories = self.showingCategories
    }
    
    func onClickSetting() {
        
    }
    
    private func getCurrentLocation() {
        if let coor = locationManager.location?.coordinate {
            let latitude = coor.latitude
            let longitude = coor.longitude
            print("위도 :\(latitude), 경도: \(longitude)")
            self.myLocation = CLLocation(latitude: latitude, longitude: longitude)
            print("myLocation :\(myLocation)")
            self.currenLocation = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: latitude, longitude: longitude), span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
            self.location = Location(latitude: latitude, longitude: longitude)
        }
    }
    
    private func getSavedData() {
        // 모든 객체 얻기
        let footPrints = realm.objects(FootPrint.self)
        self.annotations.removeAll()
        for i in footPrints {
            print(i)
            annotations.append(Pin(footPrint: i, coordinate: CLLocationCoordinate2D(latitude: i.latitude, longitude: i.longitude)))
        }
    }
    
    func onClickAnnotation(_ item: Pin) {
        print("onClickAnnotation: \(item)")
    }
    
    // MAP
    
    
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
