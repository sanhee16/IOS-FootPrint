////
////  GoogleMapVM.swift
////  Footprint
////
////  Created by sandy on 8/10/24.
////
//
//import Foundation
//import GoogleMaps
//import GooglePlaces
//import CoreLocation
//import RealmSwift
//
//class GoogleMapVM: BaseViewModel {
//    private var locationManager: CLLocationManager
//    @Published var currentTapMarker: GMSMarker? = nil
//    @Published var markerList: [MarkerItem] = []
//    @Published var myLocation: Location? = nil
//    
//    override init() {
//        print("[SD] GoogleMapVM init")
//        self.locationManager = CLLocationManager()
//        self.locationManager.allowsBackgroundLocationUpdates = false
//        self.locationManager.startUpdatingLocation()
//        
//        super.init()
//        
//        self.getCurrentLocation()
//    }
//    
//    private func getCurrentLocation() {
//        print("[SD] getCurrentLocation")
//        if let coor = locationManager.location?.coordinate {
//            let latitude = coor.latitude
//            let longitude = coor.longitude
//            print("[SD] 위도 :\(latitude), 경도: \(longitude)")
//            self.myLocation = Location(latitude: latitude, longitude: longitude)
//        }
//    }
//    
//    func createMapView() -> GMSMapView {
//        print("[SD] createMapView")
//        if let mapView = C.mapView {
//            return mapView
//        }
//        let zoom: Float = 17.8
//        let latitude: Double = self.myLocation?.latitude ?? 37.574187
//        let longitude: Double = self.myLocation?.longitude ?? 126.976882
//        
//        let camera = GMSCameraPosition.camera(withLatitude: latitude, longitude: longitude, zoom: zoom)
//        let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
//        
//        // 지도 setting
//        // https://developers.google.com/maps/documentation/ios-sdk/controls
//        mapView.isIndoorEnabled = false
//        mapView.isMyLocationEnabled = true
//        mapView.isBuildingsEnabled = false
//        mapView.settings.compassButton = true
//        mapView.settings.myLocationButton = true
//        
//        return mapView
//    }
//    
//    func loadAllMarkers() {
//        let realm: Realm = try! Realm()
//        self.removeCurrentMarker()
//        for item in self.markerList {
//            removeMarker(marker: item.marker)
//        }
//        self.markerList.removeAll()
////        let footPrints = realm.objects(FootPrint.self)
////            .filter({[weak self] footprint in
////                self?.showingCategories.firstIndex(of: footprint.tag) != nil && footprint.deleteTime == 0
////            })
////        
////        for footPrint in footPrints {
////            if let category = footPrint.tag.getCategory(), let marker = drawMarker(
////                location: Location(latitude: footPrint.latitude, longitude: footPrint.longitude),
////                category: category) {
////                markerList.append(MarkerItem(marker: marker, footPrint: footPrint))
////            }
////        }
//    }
//    
//    
//    func removeCurrentMarker() {
//        if let currentTapMarker = self.currentTapMarker {
//            self.removeMarker(marker: currentTapMarker)
//        }
//    }
//    
//    func removeMarker(marker: GMSMarker) {
//        marker.map = nil
//    }
//    
//    func drawCurrentMarker(_ location: Location) {
//        // 마커 생성하기
//        self.removeCurrentMarker()
//        self.currentTapMarker = nil
//        
//        let marker = GMSMarker(position: CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude))
//        let itemSize = CGSize(width: 20, height: 30)
//        
//        guard let image = UIImage(named: "icon_mark")?.resizeImageTo(size: itemSize) else { return }
//        
//        marker.icon = image
//        marker.map = C.mapView
//        marker.tracksViewChanges = false
//        marker.isTappable = true
//        marker.map = C.mapView
//        
//        self.currentTapMarker = marker
//    }
//    
//    func addNewMarker(_ location: Location, name: String? = nil, placeId: String? = nil, address: String? = nil) {
//        // 마커 생성하기
//        let marker = GMSMarker(position: CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude))
//        
//        let image: UIImage? = UIImage(named: PinType.star.marker)?.resizeImageTo(size: CGSize(width: 20, height: 20))
//        let markerView = UIImageView(image: image!.withRenderingMode(.alwaysTemplate))
//        
//        markerView.tintColor = PinColor.pin0.pinUIColor
//        marker.iconView = markerView
//        var message: String = "alert_add_marker_location".localized()
//        if let name = name {
//            message = "alert_add_marker_name".localized("\(name)")
//        }
//        
//        // TODO: alert
//        //        self.alert(.yesOrNo, title: message) {[weak self] res in
//        //            guard let self = self else { return }
//        //            if res {
//        //                print("add New Marker ok")
//        //                marker.map = nil
//        //                self.coordinator?.presentAddFootprintView(location: location, type: .new(name: name, placeId: placeId, address: address)) {[weak self] in
//        //                    guard let self = self else { return }
//        //                    self.loadAllMarkers()
//        //                }
//        //            } else {
//        //                self.removeCurrentMarker()
//        //                print("add New Marker cancel")
//        //                marker.map = nil
//        //            }
//        //        }
//    }
//    
//    func onTapMarker(_ location: Location) {
//        print("[SD] on tap marker")
//        self.removeCurrentMarker()
//        
//        // TODO: presentShowFootPrintView
////        self.coordinator?.presentShowFootPrintView(location, onDismiss: {[weak self] in
////            guard let self = self else { return }
////            self.removeCurrentMarker()
////        })
//    }
//}
