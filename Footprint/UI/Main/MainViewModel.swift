//
//  MainViewModel.swift
//  Footprint
//
//  Created by Studio-SJ on 2022/10/05.
// realm : https://velog.io/@dlskawns96/Swift-Realm%EC%9D%98-%ED%8A%B9%EC%A7%95%EA%B3%BC-%EC%82%AC%EC%9A%A9%EB%B2%95


import Foundation
import Combine
//import MapKit
import RealmSwift
//import NMapsMap
import GoogleMaps
import GooglePlaces
import CoreLocation

struct Pin: Identifiable {
    let id = UUID()
    let footPrint: FootPrint
    let coordinate: CLLocationCoordinate2D
}

class MainViewModel: BaseViewModel {
    private var locationManager: CLLocationManager
    //    @Published var currenLocation: MKCoordinateRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0), span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
    @Published var annotations: [Pin] = []
    
    @Published var myLocation: Location? = nil
    @Published var markerList: [MarkerItem] = []
    
//    @Published var isShowCategoriesPannel: Bool = false
    @Published var isShowingSearchResults: Bool = false
    @Published var categories: [Category] = []
    @Published var showingCategories: [Int] = []
    @Published var searchText: String = ""
    @Published var searchItems: [SearchItemResponse] = []
    @Published var locationPermission: Bool = false
    
    private var currentTapMarker: GMSMarker? = nil
    private var allFootprints: [FootPrint] = []
    
    private var mapView: GMSMapView = GMSMapView()
    private var searchTimer: Timer? = nil
    private var searchCnt: Int = 0
    private var lastSearchText: String? = nil
    private let realm: Realm
    private let googleApi: GoogleApi
    
    override init(_ coordinator: AppCoordinator) {
        self.realm = try! Realm()
        self.locationManager = CLLocationManager()
        self.locationManager.allowsBackgroundLocationUpdates = true
        self.googleApi = GoogleApi.instance
        super.init(coordinator)
    }
    
    func onAppear() {
        print("onAppear")
        switch checkLocationPermission() {
        case .allow:
            self.locationPermission = true
            getCurrentLocation()
            loadCategories()
        default:
            self.locationPermission = false
            self.myLocation = Location(latitude: 0.0, longitude: 0.0)
            break
        }
        if let myLocation = self.myLocation {
            self.moveCamera(CLLocationCoordinate2D(latitude: myLocation.latitude, longitude: myLocation.longitude))
        }
        self.loadAllMarkers()
        self.loadAllFootprints()
    }
    
    func viewDidLoad() {
        print("viewDidLoad")
        switch checkLocationPermission() {
        case .allow:
            self.locationPermission = true
            getCurrentLocation()
            loadCategories()
        default:
            self.locationPermission = false
            self.myLocation = Location(latitude: 0.0, longitude: 0.0)
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
        self.removeCurrentMarker()
        if let idx = self.showingCategories.firstIndex(of: category.tag) {
            self.showingCategories.remove(at: idx)
        } else {
            self.showingCategories.append(category.tag)
        }
        Defaults.showingCategories = self.showingCategories
        self.loadAllMarkers()
    }
    
    func onClickSetting() {
        self.removeCurrentMarker()
        self.coordinator?.presentSettingView()
    }
    
    func onClickFootprintList() {
        self.removeCurrentMarker()
        self.coordinator?.presentFootprintListView()
    }
    
    func onClickTravelList() {
        self.removeCurrentMarker()
        self.coordinator?.presentTravelListView()
    }
    
    private func getCurrentLocation() {
        if let coor = locationManager.location?.coordinate {
            let latitude = coor.latitude
            let longitude = coor.longitude
            print("위도 :\(latitude), 경도: \(longitude)")
            //            self.currenLocation = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: latitude, longitude: longitude), span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
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
    
    // MAP
    func initMapView(_ mapView: GMSMapView) {
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
            if let category = footPrint.tag.getCategory(), let marker = drawMarker(
                mapView,
                location: Location(latitude: footPrint.latitude, longitude: footPrint.longitude),
                category: category) {
                markerList.append(MarkerItem(marker: marker, footPrint: footPrint))
            }
        }
        self.stopProgress()
    }
    
    
    func removeMarker(_ mapView: GMSMapView, marker: GMSMarker) {
        //        marker.mapView = nil
        marker.map = nil
    }
    
    func onClose() {
        self.dismiss()
    }
    
    func onTapMarker(_ location: Location) {
        print("on tap marker")
        self.removeCurrentMarker()
        //        drawCurrentMarker(location)
        self.coordinator?.presentShowFootPrintView(location, onDismiss: {[weak self] in
            guard let self = self else { return }
            self.removeCurrentMarker()
        })
    }
    
    func drawCurrentMarker(_ location: Location) {
        // 마커 생성하기
        self.currentTapMarker = nil
        let marker = GMSMarker(position: CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude))
        
        let image: UIImage? = UIImage(named: "pin0")?.resizeImageTo(size: CGSize(width: 20, height: 20))
        let markerView = UIImageView(image: image!.withRenderingMode(.alwaysTemplate))
        markerView.tintColor = .greenTint2
        marker.iconView = markerView
        
        marker.map = self.mapView
        self.currentTapMarker = marker
    }
    
    
    func addNewMarker(_ location: Location, name: String? = nil, placeId: String? = nil, address: String? = nil) {
        // 마커 생성하기
        let marker = GMSMarker(position: CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude))
        
        let image: UIImage? = UIImage(named: PinType.star.marker)?.resizeImageTo(size: CGSize(width: 20, height: 20))
        let markerView = UIImageView(image: image!.withRenderingMode(.alwaysTemplate))
        
        markerView.tintColor = PinColor.pin0.pinUIColor
        marker.iconView = markerView
        var message: String = "해당 위치에 마커를 추가하시겠습니까?"
        if let name = name {
            message = "\(name)에 마커를 추가하시겠습니까?"
        }
        self.alert(.yesOrNo, title: message) {[weak self] res in
            guard let self = self else { return }
            if res {
                print("add New Marker ok")
                marker.map = nil
                self.coordinator?.presentAddFootprintView(location: location, type: .new(name: name, placeId: placeId, address: address)) {[weak self] in
                    guard let self = self else { return }
                    self.loadAllMarkers()
                }
            } else {
                print("add New Marker cancel")
                marker.map = nil
            }
        }
    }
    
    func drawMarker(_ mapView: GMSMapView, location: Location, category: Category) -> GMSMarker? {
        // 마커 생성하기
        // MARK: mix two images!
        // reference: https://stackoverflow.com/questions/32006128/how-to-merge-two-uiimages
        let marker = GMSMarker(position: CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude))
        
        var backgroundSize = CGSize(width: 130, height: 130)
        var itemSize = CGSize(width: 100, height: 100)
        var itemFinalSize = CGSize(width: 22, height: 22)
        let markerImage: UIImage? = UIImage(named: category.pinType.pinType().pinWhite)?.resizeImageTo(size: itemSize)
        var backgroundImage: UIImage? = UIImage(named: "mark_background_black")?.resizeImageTo(size: backgroundSize)
        backgroundImage = backgroundImage?.withTintColor(category.pinColor.pinColor().pinUIColor, renderingMode: .alwaysTemplate)
        
        guard let markerImage = markerImage, let backgroundImage = backgroundImage else { return nil }
        
        let backgroundRect = CGRect(x: 0, y: 0, width: backgroundSize.width, height: backgroundSize.height)
        let itemRect = CGRect(x: (backgroundSize.width - itemSize.width) / 2, y: (backgroundSize.height - itemSize.height) / 2, width: itemSize.width, height: itemSize.height)
        
        UIGraphicsBeginImageContext(backgroundSize)
        backgroundImage.draw(in: backgroundRect, blendMode: .normal, alpha: 1)
        markerImage.draw(in: itemRect, blendMode: .normal, alpha: 1)
        
        var finalMarkerImage: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        guard let finalMarkerImage = finalMarkerImage?.resizeImageTo(size: itemFinalSize) else { return nil }
        let finalMarkerImageView = UIImageView(image: finalMarkerImage.withRenderingMode(.alwaysOriginal))
        marker.iconView = finalMarkerImageView
        marker.map = self.mapView
        marker.tracksViewChanges = false
        marker.isTappable = true
        
        return marker
    }
    
    
    func loadAllFootprints() {
        self.allFootprints = Array(self.realm.objects(FootPrint.self))
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
        self.searchText = ""
        self.lastSearchText = nil
        self.searchItems = []
        self.isShowingSearchResults = false
    }
    
    func onClickSearchCancel() {
        self.stopRepeatTimer()
        self.searchText = ""
        self.lastSearchText = nil
        self.searchItems = []
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
        self.startProgress()
        let filter = GMSAutocompleteFilter()
        let searchBound: Double = 2.0
        let northEastBounds = CLLocationCoordinate2DMake(myLocation.latitude + searchBound, myLocation.longitude + searchBound);
        let southWestBounds = CLLocationCoordinate2DMake(myLocation.latitude - searchBound, myLocation.longitude - searchBound);
        filter.locationBias = GMSPlaceRectangularLocationOption(northEastBounds, southWestBounds);
        
        let placesClient: GMSPlacesClient = GMSPlacesClient()
        placesClient.findAutocompletePredictions(fromQuery: text, filter: filter, sessionToken: nil, callback: {[weak self] (results, error) in
            guard let self = self else {
                self?.stopProgress()
                return
            }
            if let error = error {
                print("Autocomplete error: \(error)")
                self.searchItems.removeAll()
                self.stopProgress()
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
            self.stopProgress()
        })
    }
    
    func onClickSearchItem(_ item: SearchItemResponse) {
        self.startProgress()
        self.googleApi.getGeocoding(item.placeId)
            .run(in: &self.subscription) {[weak self] results in
                guard let self = self, let result = results.first else {
                    self?.stopProgress()
                    return
                }
                let lat: Double = result.geometry.location.lat
                let lng: Double = result.geometry.location.lng
                let clLocation: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: lat, longitude: lng)
                self.stopProgress()
                self.moveCamera(clLocation)
                self.onCloseSearchBox()
            } err: {[weak self] err in
                print("error: \(err)")
                self?.stopProgress()
                self?.alert(.ok, title: "정보를 불러올 수 없습니다.")
            } complete: {
                print("complete")
            }
    }
    
    private func moveCamera(_ location: CLLocationCoordinate2D) {
        self.mapView.animate(toLocation: location)
    }
    
    func onClickLocationPermission() {
        self.removeCurrentMarker()
        self.alert(.yesOrNo, title: "원활한 사용을 위해 위치권한이 필요합니다.", description: "OK를 누르면 권한설정으로 이동합니다.") { isAllow in
            if isAllow {
                guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
                
                if UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url)
                }
            }
        }
    }
    
    private func removeCurrentMarker() {
        if let currentTapMarker = self.currentTapMarker {
            self.removeMarker(self.mapView, marker: currentTapMarker)
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
