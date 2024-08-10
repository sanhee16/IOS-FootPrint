//
//  MapVM2.swift
//  Footprint
//
//  Created by sandy on 8/10/24.
//

import Foundation
import Combine
import RealmSwift
import GoogleMaps
import GooglePlaces
import CoreLocation
import Contacts

struct Pin: Identifiable {
    let id = UUID()
    let footPrint: FootPrint
    let coordinate: CLLocationCoordinate2D
}

enum MarkerStatus {
    case stable
    case move
    
    var image: String {
        switch self {
        case .stable:
            return "State=able"
        case .move:
            return "State=move"
        }
    }
    
    var size: CGSize {
        switch self {
        case .stable:
            return CGSize(width: 46, height: 54)
        case .move:
            return CGSize(width: 46, height: 72)
        }
    }
}

class MapVM2: BaseViewModel {
    private var locationManager: CLLocationManager
    @Published var isShowAds: Bool = false
    @Published var annotations: [Pin] = []
    
    @Published var myLocation: Location? = nil
    @Published var markerList: [MarkerItem] = []
    
    @Published var isShowingSearchResults: Bool = false
    @Published var categories: [Category] = []
    @Published var showingCategories: [Int] = []
    @Published var searchText: String = ""
    @Published var searchItems: [SearchItemResponse] = []
    @Published var locationPermission: Bool = false
    @Published var searchTimer: Timer? = nil
    @Published var isGettingLocation: Bool = true
    
    @Published var selectedMarker: GMSMarker? = nil
    @Published var centerMarkerStatus: MarkerStatus = .stable
    @Published var centerAddress: String = ""
    
    var centerPosition: CLLocationCoordinate2D? = nil
    private var allFootprints: [FootPrint] = []
    
    private var searchCnt: Int = 0
    private var lastSearchText: String? = nil
    private let realm: Realm
    private let googleApi: GoogleApi
    
    
    override init() {
        print("[SD] init")
        self.realm = R.realm
        self.locationManager = CLLocationManager()
        self.locationManager.allowsBackgroundLocationUpdates = false
        self.googleApi = GoogleApi.instance
        super.init()
        
        Remote.init().getIsShowAds({[weak self] value in
            DispatchQueue.main.async {
                self?.isShowAds = value
                print("isShowAds: \(String(describing: self?.isShowAds))")
            }
        })
        
        self.getCurrentLocation()
    }
    
    func onAppear() {
        print("[SD] onAppear: \(C.isFirstAppStart)")
        self.removeSelectedMarker()
        switch checkLocationPermission() {
        case .allow:
            self.locationPermission = true
//            getCurrentLocation()
        default:
            self.isGettingLocation = false
            self.locationPermission = false
            self.myLocation = Location(latitude: 37.574187, longitude: 126.976882)
            break
        }
        
        loadCategories()
        C.mapView = self.createMapView()
        
        if let myLocation = self.myLocation, C.isFirstAppStart {
            C.isFirstAppStart = false
            self.moveCamera(CLLocationCoordinate2D(latitude: myLocation.latitude, longitude: myLocation.longitude))
        }
        self.loadAllMarkers()
        self.loadAllFootprints()
    }
    
//    func viewDidLoad() {
//        print("[SD] viewDidLoad")
//        switch checkLocationPermission() {
//        case .allow:
//            self.locationPermission = true
//            getCurrentLocation()
//            loadCategories()
//        default:
//            self.isGettingLocation = false
//            self.locationPermission = false
//            self.myLocation = Location(latitude: 0.0, longitude: 0.0)
//            break
//        }
//        self.loadAllMarkers()
//        self.loadAllFootprints()
//    }
    func didTapMyLocationButton() {
        guard let myLocation = self.myLocation else { return }
        self.moveCamera(CLLocationCoordinate2D(latitude: myLocation.latitude, longitude: myLocation.longitude))
    }

    private func loadCategories() {
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
        self.removeSelectedMarker()
        if let idx = self.showingCategories.firstIndex(of: category.tag) {
            self.showingCategories.remove(at: idx)
        } else {
            self.showingCategories.append(category.tag)
        }
        Defaults.showingCategories = self.showingCategories
        self.loadAllMarkers()
    }
    
//    override func onClickMenu(_ type: MainMenuType) {
//        self.removeCurrentMarker()
//        super.onClickMenu(type)
//    }
    
    private func getCurrentLocation() {
        if let coor = locationManager.location?.coordinate {
            let latitude = coor.latitude
            let longitude = coor.longitude
            print("위도 :\(latitude), 경도: \(longitude)")
            self.myLocation = Location(latitude: latitude, longitude: longitude)
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
    
    //MARK: MAP
    func createMapView() -> GMSMapView {
        if let mapView = C.mapView {
            return mapView
        }
        let zoom: Float = 17.8
        print("[MAP VIEW] createMapView")
        let latitude: Double = self.myLocation?.latitude ?? 37.574187
        let longitude: Double = self.myLocation?.longitude ?? 126.976882
        
        let camera = GMSCameraPosition.camera(withLatitude: latitude, longitude: longitude, zoom: zoom)
        let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        
        // 지도 setting
        // https://developers.google.com/maps/documentation/ios-sdk/controls
        mapView.isIndoorEnabled = false
        mapView.isMyLocationEnabled = true
        mapView.isBuildingsEnabled = false
        mapView.settings.compassButton = true
        
        return mapView
    }
    
    func loadAllMarkers() {
        print("[SD] loadAllMarkers")
        self.removeSelectedMarker()
        for item in self.markerList {
            removeMarker(marker: item.marker)
        }
        self.markerList.removeAll()
        let footPrints = realm.objects(FootPrint.self)
            .filter({[weak self] footprint in
                self?.showingCategories.firstIndex(of: footprint.tag) != nil && footprint.deleteTime == 0
            })
        
        for footPrint in footPrints {
            if let category = footPrint.tag.getCategory(), let marker = drawMarker(
                location: Location(latitude: footPrint.latitude, longitude: footPrint.longitude),
                category: category) {
                markerList.append(MarkerItem(marker: marker, footPrint: footPrint))
            }
        }
    }
    
    
    func removeMarker(marker: GMSMarker) {
        marker.map = nil
    }
    
    func onTapMarker(_ location: Location) {
        print("[SD] on tap marker")
        self.removeSelectedMarker()
        
        // TODO: presentShowFootPrintView
//        self.coordinator?.presentShowFootPrintView(location, onDismiss: {[weak self] in
//            guard let self = self else { return }
//            self.removeCurrentMarker()
//        })
    }
    
    func addNewMarker(_ location: Location, name: String? = nil, placeId: String? = nil, address: String? = nil) {
        // 마커 생성하기
        let marker = GMSMarker(position: CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude))
        
        let image: UIImage? = UIImage(named: PinType.star.marker)?.resizeImageTo(size: CGSize(width: 20, height: 20))
        let markerView = UIImageView(image: image!.withRenderingMode(.alwaysTemplate))
        
        markerView.tintColor = PinColor.pin0.pinUIColor
        marker.iconView = markerView
        var message: String = "alert_add_marker_location".localized()
        if let name = name {
            message = "alert_add_marker_name".localized("\(name)")
        }
        
        // TODO: alert
        self.viewEvent = .goToFootprintView(location: location)
        
//        self.alert(.yesOrNo, title: message) {[weak self] res in
//            guard let self = self else { return }
//            if res {
//                print("add New Marker ok")
//                marker.map = nil
//                self.coordinator?.presentAddFootprintView(location: location, type: .new(name: name, placeId: placeId, address: address)) {[weak self] in
//                    guard let self = self else { return }
//                    self.loadAllMarkers()
//                }
//            } else {
//                self.removeCurrentMarker()
//                print("add New Marker cancel")
//                marker.map = nil
//            }
//        }
    }
    
    func drawMarker(location: Location, category: Category) -> GMSMarker? {
        // 마커 생성하기
        // MARK: mix two images!
        // reference: https://stackoverflow.com/questions/32006128/how-to-merge-two-uiimages
        let marker = GMSMarker(position: CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude))
        
        let backgroundSize = CGSize(width: 130, height: 130)
        let itemSize = CGSize(width: 100, height: 100)
        let itemFinalSize = CGSize(width: 22, height: 22)
        let markerImage: UIImage? = UIImage(named: category.pinType.pinType().pinWhite)?.resizeImageTo(size: itemSize)
        var backgroundImage: UIImage? = UIImage(named: "mark_background_black")?.resizeImageTo(size: backgroundSize)
        backgroundImage = backgroundImage?.withTintColor(category.pinColor.pinColor().pinUIColor, renderingMode: .alwaysTemplate)
        
        guard let markerImage = markerImage, let backgroundImage = backgroundImage else { return nil }
        
        let backgroundRect = CGRect(x: 0, y: 0, width: backgroundSize.width, height: backgroundSize.height)
        let itemRect = CGRect(x: (backgroundSize.width - itemSize.width) / 2, y: (backgroundSize.height - itemSize.height) / 2, width: itemSize.width, height: itemSize.height)
        
        UIGraphicsBeginImageContext(backgroundSize)
        backgroundImage.draw(in: backgroundRect, blendMode: .normal, alpha: 1)
        markerImage.draw(in: itemRect, blendMode: .normal, alpha: 1)
        
        let finalMarkerImage: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        guard let finalMarkerImage = finalMarkerImage?.resizeImageTo(size: itemFinalSize) else { return nil }
        let finalMarkerImageView = UIImageView(image: finalMarkerImage.withRenderingMode(.alwaysOriginal))
        marker.iconView = finalMarkerImageView
        marker.map = C.mapView
        marker.tracksViewChanges = false
        marker.isTappable = true
        
        return marker
    }
    
    func drawSelectedMarker(_ location: Location) {
        // 마커 생성하기
        self.removeSelectedMarker()
        self.selectedMarker = nil

        let marker = GMSMarker(position: CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude))
        let itemSize = CGSize(width: 46, height: 54)
        guard let image = UIImage(named: "State=able")?.resizeImageTo(size: itemSize) else { return }
        
        marker.icon = image
        marker.map = C.mapView
        marker.tracksViewChanges = false
        marker.isTappable = true
        marker.map = C.mapView
        
        self.selectedMarker = marker
    }
    
    func changeStateSelectedMarker(_ isDrag: Bool, target: CLLocationCoordinate2D?) {
//        let itemSize = isDrag ? CGSize(width: 46, height: 72) : CGSize(width: 46, height: 54)
//        guard let image = UIImage(named: isDrag ? "State=move" : "State=able")?.resizeImageTo(size: itemSize) else { return }
//        self.selectedMarker?.icon = image
        self.centerMarkerStatus = isDrag ? .move : .stable
        self.centerPosition = target
        
        guard let target = target else { return }
        let location = CLLocation(latitude: target.latitude, longitude: target.longitude)
        let geocoder = CLGeocoder()
        let locale = Locale(identifier: "Ko-kr")
        
        geocoder.reverseGeocodeLocation(location, preferredLocale: locale) { [weak self] placemarks, _ in
            guard let placemarks = placemarks,
                  let address = placemarks.last
            else { return }
            
            if let postalAddress = address.postalAddress {
                let formatter = CNPostalAddressFormatter()
                let addressString = formatter.string(from: postalAddress)
                
                print("addressString: \(addressString)")
                var result: String = ""
                addressString.split(separator: "\n").forEach { value in
                    result.append(contentsOf: "\(value) ")
                }
                self?.centerAddress = result
                print("result: \(result)")
            }
        }

    }
    
    func loadAllFootprints() {
        self.allFootprints.removeAll()
        self.allFootprints = Array(self.realm.objects(FootPrint.self))
            .filter({footprint in
                footprint.deleteTime == 0
            })
    }
    
    func enterSearchText() {
        let text = self.searchText
        if text.isEmpty {
            self.stopRepeatTimer()
            self.searchText = ""
            self.lastSearchText = nil
            return
        }
        if !self.isShowingSearchResults {
            self.isShowingSearchResults = true
        }
        print("enter text: \(text)")
        searchCnt = 0
        if self.searchTimer == nil {
            self.startRepeatTimer()
        }
    }
    
    func onCloseSearchBox() {
        self.stopRepeatTimer()
        self.lastSearchText = self.searchText
//        self.lastSearchItems = self.searchItems
        
//        self.searchText = ""
//        self.searchItems = []
        self.isShowingSearchResults = false
    }
    
    func onClickSearchCancel() {
        self.stopRepeatTimer()
        self.lastSearchText = nil
//        self.lastSearchItems = []
        
        self.searchText = ""
        self.searchItems = []
    }
    
    func onTapSearchBox() {
        if (isShowingSearchResults == true) || (isShowingSearchResults == false && self.searchItems.isEmpty) {
            return
        }
        isShowingSearchResults = true
    }
    
    private func timerStopAndTask() {
        if let lastSearchText = self.lastSearchText, lastSearchText == self.searchText {
            return
        }
        self.lastSearchText = self.searchText
        self.placeSearch(self.searchText)
    }
    
    // https://developers.google.com/maps/documentation/places/ios-sdk/autocomplete#get_place_predictions
    private func placeSearch(_ text: String) {
        guard let myLocation = myLocation else { return }
        let filter = GMSAutocompleteFilter()
        let searchBound: Double = 2.0
        let northEastBounds = CLLocationCoordinate2DMake(myLocation.latitude + searchBound, myLocation.longitude + searchBound);
        let southWestBounds = CLLocationCoordinate2DMake(myLocation.latitude - searchBound, myLocation.longitude - searchBound);
        filter.locationBias = GMSPlaceRectangularLocationOption(northEastBounds, southWestBounds);
        
        let placesClient: GMSPlacesClient = GMSPlacesClient()
        placesClient.findAutocompletePredictions(fromQuery: text, filter: filter, sessionToken: nil, callback: {[weak self] (results, error) in
            guard let self = self else {
                return
            }
            if let error = error {
                print("Autocomplete error: \(error)")
                self.searchItems.removeAll()
                return
            }
            if let results = results {
                self.searchItems.removeAll()
                for result in results {
                    self.searchItems.append(
                        SearchItemResponse(
                            name: result.attributedPrimaryText.string,
                            fullAddress: result.attributedFullText.string,
                            secondaryAddress: result.attributedSecondaryText?.string,
                            placeId: result.placeID,
                            types: result.types
                        )
                    )
                }
            }
        })
    }
    
    func onClickSearchItem(_ item: SearchItemResponse) {
        //TODO: GetGeocoding
//        self.googleApi.getGeocoding(item.placeId)
//            .run(in: &self.subscription) {[weak self] results in
//                guard let self = self, let result = results.first else {
//                    return
//                }
//                let lat: Double = result.geometry.location.lat
//                let lng: Double = result.geometry.location.lng
//                let clLocation: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: lat, longitude: lng)
//                self.moveCamera(clLocation)
//                // icon_mark
//                self.drawCurrentMarker(Location(latitude: lat, longitude: lng))
//                self.onCloseSearchBox()
//            } err: {[weak self] err in
//                print("error: \(err)")
//                //TODO: Alert
////                self?.alert(.ok, title: "alert_cannot_load_information".localized())
//            } complete: {
//                print("complete")
//            }
    }
    
    private func moveCamera(_ location: CLLocationCoordinate2D) {
        C.mapView?.animate(toLocation: location)
    }
    
    func onClickLocationPermission() {
        self.removeSelectedMarker()
        //TODO: Alert
//        self.alert(.yesOrNo, title: "alert_request_permission_location".localized(), description: "alert_request_permission_location_description".localized()) { isAllow in
//            if isAllow {
//                guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
//                
//                if UIApplication.shared.canOpenURL(url) {
//                    UIApplication.shared.open(url)
//                }
//            }
//        }
    }
    
    func removeSelectedMarker() {
        if let currentTapMarker = self.selectedMarker {
            self.removeMarker(marker: currentTapMarker)
        }
    }
    
    //MARK: Timer
    // 반복 타이머 시작
    private func startRepeatTimer() {
        searchTimer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(timerTask(timer:)), userInfo: "check permission", repeats: true)
    }
    
    // 반복 타이머 실행, 타이머 돌때 할 작업
    @objc private func timerTask(timer: Timer) {
        if timer.userInfo != nil {
            searchCnt += 1
            print("timer run : \(searchCnt)")
            if searchCnt == 4 {
                stopRepeatTimer()
                // timer 종료되고 할 작업
                self.timerStopAndTask()
            }
        }
    }
    
    
    // 반복 타이머 종료
    private func stopRepeatTimer() {
        if let timer = searchTimer {
            print("timer stop!")
            if timer.isValid {
                timer.invalidate()
            }
            searchTimer = nil
            searchCnt = 0
        }
    }
}
