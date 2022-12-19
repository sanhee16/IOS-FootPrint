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
    //    private var api: Api = Api.instance
    private var locationManager: CLLocationManager
    @Published var myLocation: CLLocation? = nil
    @Published var currenLocation: MKCoordinateRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0), span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
    @Published var annotations: [Pin] = []
    
    @Published var location: Location? = nil
    @Published var markerList: [MarkerItem] = []
    
    @Published var isShowCategoriesPannel: Bool = false
    @Published var isShowingSearchPannel: Bool = false
    @Published var categories: [Category] = []
    @Published var showingCategories: [Int] = []
    @Published var serachText: String = ""
    @Published var searchItems: [FootPrint] = []
    @Published var locationPermission: Bool = false
    
    private var allFootprints: [FootPrint] = []
    
    private var mapView: NMFMapView = NMFMapView()
    private let realm: Realm
    
    override init(_ coordinator: AppCoordinator) {
        self.realm = try! Realm()
        self.locationManager = CLLocationManager()
        self.locationManager.allowsBackgroundLocationUpdates = true
        super.init(coordinator)
    }
    
    func onAppear() {
        print("onAppear")
        //        getSavedData()
        switch checkLocationPermission() {
        case .allow:
            self.locationPermission = true
            getCurrentLocation()
            loadCategories()
        default:
            self.locationPermission = false
            self.location = Location(latitude: 0.0, longitude: 0.0)
            break
        }
        self.loadAllMarkers()
        self.loadAllFootprints()
    }
    
    private func loadCategories() {
        print("sandy loadCategories")
        // 객체 초기화
        self.categories = []
        
        // 모든 객체 얻기
        self.showingCategories = Defaults.showingCategories
        let dbCategories = realm.objects(Category.self).sorted(byKeyPath: "tag", ascending: true)
        for i in dbCategories {
            self.categories.append(Category(tag: i.tag, name: i.name, pinType: i.pinType.pinType(), pinColor: i.pinColor.pinColor()))
        }
    }
    
    func onClickCategory(_ category: Category) {
        if let idx = self.showingCategories.firstIndex(of: category.tag) {
            self.showingCategories.remove(at: idx)
        } else {
            self.showingCategories.append(category.tag)
        }
        Defaults.showingCategories = self.showingCategories
        self.loadAllMarkers()
    }
    
    func onClickSetting() {
        self.coordinator?.presentSettingView()
    }
    
    func onClickFootprintList() {
        self.coordinator?.presentFootprintListView()
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
    func initMapView(_ mapView: NMFMapView) {
        self.mapView = mapView
    }
    
    func loadAllMarkers() {
        print("load all Markers")
        self.startProgress()
        
        for item in self.markerList {
            removeMarker(self.mapView, marker: item.marker)
        }
        self.markerList.removeAll()
        let footPrints = realm.objects(FootPrint.self)
            .filter({[weak self] category in
                self?.showingCategories.firstIndex(of: category.tag) != nil
            })
        
        for footPrint in footPrints {
            if let category = footPrint.tag.getCategory() {
                markerList.append(
                    MarkerItem(marker:
                                drawMarker(
                                    mapView,
                                    location: Location(latitude: footPrint.latitude, longitude: footPrint.longitude),
                                    category: category),
                               footPrint: footPrint)
                )
            }
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
    }
    
    func addNewMarker(_ location: Location) {
        // 마커 생성하기
        let marker = NMFMarker()
        marker.position = NMGLatLng(lat: location.latitude, lng: location.longitude)
        
        // 마커 그룹
        //        marker.tag = IntValue
        
        // marker 사이즈 지정
        marker.width = 20
        marker.height = 20
        
        // marker 색상 입히기
        marker.iconImage = NMFOverlayImage(name: PinType.star.marker)
        marker.iconTintColor = PinColor.pin0.pinUIColor
        marker.mapView = self.mapView
        self.alert(.yesOrNo, title: "현재 위치에 마커를 추가하시겠습니까?") {[weak self] res in
            guard let self = self else { return }
            if res {
                print("add New Marker ok")
                marker.mapView = nil
                self.coordinator?.presentAddFootprintView(location: location, type: .new) {[weak self] in
                    guard let self = self else { return }
                    self.loadAllMarkers()
                }
            } else {
                print("add New Marker cancel")
                marker.mapView = nil
            }
        }
    }
    
    func drawMarker(_ mapView: NMFMapView, location: Location, category: Category) -> NMFMarker {
        // 마커 생성하기
        let marker = NMFMarker()
        marker.position = NMGLatLng(lat: location.latitude, lng: location.longitude)
        
        // marker 사이즈 지정
        marker.width = 20
        marker.height = 20
        
        // marker 색상 입히기
        marker.iconImage = NMFOverlayImage(name: category.pinType.pinType().marker)
        marker.iconTintColor = category.pinColor.pinColor().pinUIColor
        marker.mapView = mapView
        
        marker.touchHandler = {[weak self] (overlay) in
            guard let self = self else { return false }
            self.onTapMarker(location)
            return true
        }
        return marker
    }
    
    func onTapSearchPannel() {
        self.isShowCategoriesPannel = false
        self.isShowingSearchPannel = !self.isShowingSearchPannel
        if self.isShowingSearchPannel {
            loadAllFootprints()
            self.searchItems = self.allFootprints
        } else {
            self.searchItems.removeAll()
            self.serachText.removeAll()
        }
    }
    
    func loadAllFootprints() {
        self.allFootprints = Array(self.realm.objects(FootPrint.self))
    }
    
    func enterSearchText() {
        let text = self.serachText
        if text.isEmpty {
            self.searchItems = self.allFootprints
        } else {
            self.searchItems = self.allFootprints.filter { item in
                item.title.contains(text)
            }
        }
    }
    
    func onClickSearchItem(_ item: FootPrint) {
        let cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(lat: item.latitude, lng: item.longitude))
        mapView.moveCamera(cameraUpdate)
    }
    
    func onClickLocationPermission() {
        self.alert(.yesOrNo, title: "원활한 사용을 위해 위치권한이 필요합니다.", description: "OK를 누르면 권한설정으로 이동합니다.") { isAllow in
            if isAllow {
                guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
                
                if UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url)
                }
            }
        }
    }
}
