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
    
    @Published var isShowCategoriesPannel: Bool = false
    @Published var isShowingSearchPannel: Bool = false
    @Published var categories: [Category] = []
    @Published var showingCategories: [Int] = []
    @Published var searchText: String = ""
    @Published var searchItems: [FootPrint] = []
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
        //        getSavedData()
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
    
    func viewDidLoad() {
        print("viewDidLoad")
        //        getSavedData()
        switch checkLocationPermission() {
        case .allow:
            self.locationPermission = true
            getCurrentLocation()
            loadCategories()
            //            if let myLocation = self.myLocation {
            //                let cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(lat: myLocation.latitude, lng: myLocation.longitude))
            //                self.mapView.moveCamera(cameraUpdate)
            //            }
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
    
    
    func addNewMarker(_ location: Location, name: String? = nil) {
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
                self.coordinator?.presentAddFootprintView(location: location, type: .new(name: name)) {[weak self] in
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
    
    func onTapSearchPannel() {
        self.removeCurrentMarker()
        self.isShowCategoriesPannel = false
        self.isShowingSearchPannel = !self.isShowingSearchPannel
        if self.isShowingSearchPannel {
            loadAllFootprints()
            self.searchItems = self.allFootprints
        } else {
            self.searchItems.removeAll()
            self.searchText.removeAll()
        }
    }
    
    func loadAllFootprints() {
        self.allFootprints = Array(self.realm.objects(FootPrint.self))
    }
    
    func enterSearchText() {
        let text = self.searchText
        print("enter text: \(text)")
        searchCnt = 0
        if self.searchTimer == nil {
            self.startRepeatTimer()
        }
        //TOOD: here
        // 여기에 하면 너무 api요청이 많아서 검색하고난 후에 해야할것 같음 -> 아니면 delay줘서 해야 할 것 같은데
        // example) 1초~2초 정도 더 입력이 없으면 그때 요청
        // placeSearch(text)
        
        
        
        //        if text.isEmpty {
        //            self.searchItems = self.allFootprints
        //        } else {
        //            self.searchItems = self.allFootprints.filter { item in
        //                item.title.contains(text)
        //            }
        //        }
    }
    
    private func timerStopAndTask() {
        print("timer Stop!")
        //TODO: 여기는 임시라서 이 메소드 지워야징!
        if let lastSearchText = self.lastSearchText, lastSearchText == self.searchText {
            return
        }
        self.lastSearchText = self.searchText
        self.placeSearch(self.searchText)
    }
    
    // https://developers.google.com/maps/documentation/places/ios-sdk/autocomplete#get_place_predictions
    private func placeSearch(_ text: String) {
        guard let myLocation = myLocation else { return }
        /**
         * Create a new session token. Be sure to use the same token for calling
         * findAutocompletePredictions, as well as the subsequent place details request.
         * This ensures that the user's query and selection are billed as a single session.
         */
//        let token: GMSAutocompleteSessionToken = GMSAutocompleteSessionToken.init()
        
        // Create a type filter.
        let filter = GMSAutocompleteFilter()
        //        filter.locationBias = LocationBa
        //        filter.types = [.address]
        let searchBound: Double = 2.0
        let northEastBounds = CLLocationCoordinate2DMake(myLocation.latitude + searchBound, myLocation.longitude + searchBound);
        let southWestBounds = CLLocationCoordinate2DMake(myLocation.latitude - searchBound, myLocation.longitude - searchBound);
        filter.locationBias = GMSPlaceRectangularLocationOption(northEastBounds, southWestBounds);
        
        let placesClient: GMSPlacesClient = GMSPlacesClient()
        placesClient.findAutocompletePredictions(fromQuery: text, filter: filter, sessionToken: nil, callback: { (results, error) in
            if let error = error {
                print("Autocomplete error: \(error)")
                return
            }
            var placeId: String? = nil
            if let results = results {
                placeId = results.first?.placeID
                for result in results {
                    /*
                     attributedFullText: 대한민국 서울특별시 강남구 대치동 {
                     }빈브라더{
                         GMSAutocompleteMatch = "<GMSAutocompleteMatchFragment: 0x2836944c0>";
                     }스{
                     }
                     attributedPrimaryText: 빈브라더{
                         GMSAutocompleteMatch = "<GMSAutocompleteMatchFragment: 0x283694340>";
                     }스{
                     }
                     attributedSecondaryText: Optional(대한민국 서울특별시 강남구 대치동{
                     })
                     placeID: ChIJNd4xuz-kfDURNheDT2onnUc
                     types: ["cafe", "food", "point_of_interest", "establishment"]
                     */
                    
                    /*
                     Result 대한민국 서울특별시 마포구 합정동 토정로 {
                     }빈브라더{
                     GMSAutocompleteMatch = "<GMSAutocompleteMatchFragment: 0x280770dc0>";
                     }스 합정점{
                     } with placeID ChIJr8r3XtSYfDURLs-hbLaOdow
                     */
                    
//                    print("Result \(result.attributedFullText) with placeID \(result.placeID)")
//                    print("attributedFullText: \(result.attributedFullText)")
//                    print("attributedPrimaryText: \(result.attributedPrimaryText)")
//                    print("attributedSecondaryText: \(result.attributedSecondaryText)")
//                    print("placeID: \(result.placeID)")
//                    print("types: \(result.types)")
//                    print("-----------------------------")
                    
                }
            }
            if let placeId = placeId {
                print("placeId: \(placeId)")
                self.googleApi.getGeocoding(placeId)
                    .run(in: &self.subscription) { result in
                        print("run!")
                        print(result)
//                        print("lat: \(result.geometry.location.lat)")
//                        print("lng: \(result.geometry.location.lng)")
                    } err: { err in
                        print("error: \(err)")
                    } complete: {
                        print("complete")
                    }

            }
        })
    }
    
    func onClickSearchItem(_ item: FootPrint) {
        self.removeCurrentMarker()
        //        let cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(lat: item.latitude, lng: item.longitude))
        //        mapView.moveCamera(cameraUpdate)
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
            if searchCnt == 5 {
                stopRepeatTimer()
            }
        }
    }
    
    
    // 반복 타이머 종료
    private func stopRepeatTimer() {
        if let timer = searchTimer {
            if timer.isValid {
                timer.invalidate()
            }
            searchTimer = nil
            searchCnt = 0
            // timer 종료되고 할 작업
            //            onStartSplashTimer()
            self.timerStopAndTask()
        }
    }
}
