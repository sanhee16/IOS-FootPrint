////
////  MainView.swift
////  Footprint
////
////  Created by Studio-SJ on 2022/10/05.
////
///*
// TODO: todo list
// - ✅ 날짜기능 추가
//    1. 캘린더 추가
//    2. 노트나 여행에 기록(노트는 하루 선택, default는 기록 당시 날짜, 여행은 from-to 형식)
// - 즐겨찾기 추가
//    1. 탭에 추가하기
//    2. ✅ 노트에만 추가
// - 필터기능 추가
//     1. 여행 -> 1개씩만 선택
//     2. 노트 -> 카테고리 || 함께한 사람 (or 연산)
// - 자동저장 기능 추가
//    1. 완료/저장 안눌러도 자동으로 바로바로 저장되게??
//    2. 이거 setting에 flag로 할까 말까
// */
//
//import SwiftUI
//import MapKit
//import GoogleMaps
//import GooglePlaces
//
//
//struct MainView: View {
//    typealias VM = MainViewModel
//    public static func vc(_ coordinator: AppCoordinator, completion: (()-> Void)? = nil) -> UIViewController {
//        let vm = VM.init(coordinator)
//        let view = Self.init(vm: vm)
//        let vc = BaseViewController.init(view, completion: completion) {
//            vm.viewDidLoad()
//        }
//        return vc
//    }
//    @ObservedObject var vm: VM
//    
//    private var safeTop: CGFloat { get { Util.safeTop() }}
//    private var safeBottom: CGFloat { get { Util.safeBottom() }}
//    private let optionHeight: CGFloat = 36.0
//    private let optionVerticalPadding: CGFloat = 8.0
//    
//    
//    var body: some View {
//        GeometryReader { geometry in
//            VStack(alignment: .center, spacing: 0) {
////                ZStack(alignment: .leading) {
////                    Topbar("FootPrint", type: .none) {
////                    }
////                    HStack(alignment: .center, spacing: 12) {
////                        Text("전체보기")
////                            .font(.kr12r)
////                            .foregroundColor(.textColor1)
////                            .onTapGesture {
////                                vm.onClickFootprintList()
////                            }
////                        Text("travel")
////                            .font(.kr12r)
////                            .foregroundColor(.textColor1)
////                            .onTapGesture {
////                                vm.onClickTravelList()
////                            }
////                        Spacer()
////                        Image("icon_gps")
////                            .resizable()
////                            .frame(both: 20.0, aligment: .center)
////                            .colorMultiply($vm.locationPermission.wrappedValue ? .green : .red)
////                            .padding(.trailing, 8)
////                            .onTapGesture {
////                                if !$vm.locationPermission.wrappedValue {
////                                    vm.onClickLocationPermission()
////                                }
////                            }
////                        Text("설정")
////                            .font(.kr12r)
////                            .foregroundColor(.textColor1)
////                            .onTapGesture {
////                                vm.onClickSetting()
////                            }
////                    }
////                    .frame(width: geometry.size.width - 24, height: 50, alignment: .center)
////                    .padding([.leading, .trailing], 12)
////                }
////                .frame(width: geometry.size.width, height: 50, alignment: .center)
//                //Google Map
//                if let coordinator = $vm.coordinator.wrappedValue {
//                    ZStack(alignment: .topTrailing) {
//                        VStack(alignment: .center, spacing: self.optionVerticalPadding) {
//                            if Util.getSettingStatus(.SEARCH_BAR) {
//                                drawSearchBox(geometry)
//                                if $vm.isShowingSearchResults.wrappedValue == true {
//                                    drawSearchItems(geometry)
//                                        .padding(.top, 6)
//                                }
//                            }
//                        }
//                        .zIndex(1)
//                        GoogleMapView(coordinator, vm: vm)
//                    }
//                }
//                MainMenuBar(geometry: geometry, current: .map) { type in
//                    vm.onClickMenu(type)
//                }
//                
//                //Naver Map
////                if let myLocation = $vm.location.wrappedValue, let coordinator = $vm.coordinator.wrappedValue {
////                    ZStack(alignment: .topTrailing) {
////                        MapView(coordinator, location: myLocation, vm: vm)
////                        VStack(alignment: .center, spacing: 0) {
////                            drawSearch(geometry)
////                            if !$vm.isShowingSearchPannel.wrappedValue {
////                                drawCategory(geometry)
////                            }
////                        }
////                        .zIndex(2)
////                        if $vm.isShowingSearchPannel.wrappedValue {
////                            ScrollView(.vertical, showsIndicators: false) {
////                                VStack(alignment: .leading, spacing: 8) {
////                                    ForEach($vm.searchItems.wrappedValue.indices, id: \.self) { idx in
////                                        let item = $vm.searchItems.wrappedValue[idx]
////                                        drawSearchItem(geometry, item: item)
////                                    }
////                                }
////                            }
////                            .padding(EdgeInsets(top: 12, leading: 10, bottom: 12, trailing: 10))
////                            .background(
////                                RoundedRectangle(cornerRadius: 6)
////                                    .foregroundColor(Color.white.opacity(0.9))
////                            )
////                            .zIndex(1)
////                            .frame(width: geometry.size.width - 20, height: geometry.size.height / 3, alignment: .center)
////                            .padding(EdgeInsets(top: 60, leading: 10, bottom: 0, trailing: 10))
////                            .ignoresSafeArea(.container, edges: [.bottom])
////                        }
////                    }
////                }
//            }
//            .frame(width: geometry.size.width, alignment: .center)
//        }
//        .onAppear {
//            vm.onAppear()
//        }
//    }
//    
//    private func drawSearchItems(_ geometry: GeometryProxy) -> some View {
//        return VStack(alignment: .leading, spacing: 0) {
//            ZStack(alignment: .center) {
//                if $vm.searchTimer.wrappedValue != nil {
//                    VStack(alignment: .center, spacing: 8) {
//                        Spacer()
//                        HStack(alignment: .center, spacing: 0) {
//                            Spacer()
//                            SandyProgressView(size: 130.0)
//                            Spacer()
//                        }
//                        .frame(width: geometry.size.width - 20, height: geometry.size.height / 5 * 2, alignment: .center)
//                        Spacer()
//                    }
//                    .frame(width: geometry.size.width - 20, height: geometry.size.height / 5 * 2, alignment: .center)
//                    .zIndex(1)
//                }
//                ScrollView(.vertical, showsIndicators: true) {
//                    VStack(alignment: .leading, spacing: 8) {
//                        ForEach($vm.searchItems.wrappedValue.indices, id: \.self) { idx in
//                            searchItem(geometry, item: $vm.searchItems.wrappedValue[idx])
//                        }
//                    }
//                    .padding(EdgeInsets(top: 12, leading: 8, bottom: 12, trailing: 6))
//                }
//                .frame(width: geometry.size.width - 20, height: geometry.size.height / 5 * 2, alignment: .leading)
//            }
//            .frame(width: geometry.size.width - 20, height: geometry.size.height / 5 * 2, alignment: .leading)
//        }
//        .background(
//            RoundedRectangle(cornerRadius: 6)
//                .foregroundColor(Color.white.opacity(0.90))
//        )
//        .frame(width: geometry.size.width - 20, height: geometry.size.height / 5 * 2, alignment: .leading)
//        .padding([.leading, .trailing], 10)
//    }
//    
//    private func searchItem(_ geometry: GeometryProxy, item: SearchItemResponse) -> some View {
//        return VStack(alignment: .leading, spacing: 6) {
//            Text(item.name)
//                .font(.kr12r)
//                .foregroundColor(.textColor1)
//            Text(item.fullAddress)
//                .font(.kr11r)
//                .foregroundColor(.gray60)
//            Divider()
//                .frame(width: geometry.size.width - 34, alignment: .center)
//        }
//        .padding([.top, .bottom], 2)
//        .frame(width: geometry.size.width - 20, alignment: .leading)
//        .contentShape(Rectangle())
//        .onTapGesture {
//            vm.onClickSearchItem(item)
//        }
//    }
//    
//    private func drawSearchBox(_ geometry: GeometryProxy) -> some View {
//        return HStack(alignment: .center, spacing: 6) {
//            ZStack(alignment: .trailing) {
//                TextField("", text: $vm.searchText)
//                    .font(.kr13r)
//                    .foregroundColor(.gray90)
//                    .accentColor(.fColor2)
//                    .padding([.leading, .trailing], 8)
//                    .frame(width: $vm.isShowingSearchResults.wrappedValue ? geometry.size.width - 20 - 60 : geometry.size.width - 20, height: self.optionHeight, alignment: .center)
//                    .contentShape(Rectangle())
//                    .background(
//                        RoundedRectangle(cornerRadius: 6)
//                            .foregroundColor(Color.white.opacity(0.98))
//                    )
//                    .border(.fColor2, lineWidth: 1.2, cornerRadius: 6)
//                    .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: $vm.isShowingSearchResults.wrappedValue ? 0 : 10))
//                    .onChange(of: $vm.searchText.wrappedValue) { _ in
//                        vm.enterSearchText()
//                    }
//                    .onTapGesture {
//                        vm.onTapSearchBox()
//                    }
//                if !$vm.searchText.wrappedValue.isEmpty {
//                    Image("close")
//                        .resizable()
//                        .frame(both: 10.0, aligment: .center)
//                        .padding(6)
//                        .background(
//                            Circle()
//                                .foregroundColor(.fColor4)
//                        )
//                        .contentShape(Rectangle())
//                        .padding(.trailing, $vm.isShowingSearchResults.wrappedValue ? 8 : 18)
//                        .zIndex(1)
//                        .onTapGesture {
//                            vm.onClickSearchCancel()
//                        }
//                }
//            }
//            if $vm.isShowingSearchResults.wrappedValue {
//                Text("닫기")
//                    .font(.kr13r)
//                    .foregroundColor(.white)
//                    .frame(width: 60, height: self.optionHeight, alignment: .center)
//                    .background(
//                        RoundedRectangle(cornerRadius: 6)
//                            .foregroundColor(Color.fColor2)
//                    )
//                    .padding(.trailing, 10)
//                    .onTapGesture {
//                        vm.onCloseSearchBox()
//                        UIApplication.shared.hideKeyborad()
//                    }
//            }
//        }
//        .padding(.top, 8)
//    }
//}
////------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
////------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
////------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
////------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
////
////  MainViewModel.swift
////  Footprint
////
////  Created by Studio-SJ on 2022/10/05.
//// realm : https://velog.io/@dlskawns96/Swift-Realm%EC%9D%98-%ED%8A%B9%EC%A7%95%EA%B3%BC-%EC%82%AC%EC%9A%A9%EB%B2%95
//
//
//import Foundation
//import Combine
////import MapKit
//import RealmSwift
////import NMapsMap
//import GoogleMaps
//import GooglePlaces
//import CoreLocation
//
//struct Pin: Identifiable {
//    let id = UUID()
//    let footPrint: FootPrint
//    let coordinate: CLLocationCoordinate2D
//}
//
//class MainViewModel: BaseViewModel {
//    private var locationManager: CLLocationManager
//    //    @Published var currenLocation: MKCoordinateRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0), span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
//    @Published var annotations: [Pin] = []
//    
//    @Published var myLocation: Location? = nil
//    @Published var markerList: [MarkerItem] = []
//    
////    @Published var isShowCategoriesPannel: Bool = false
//    @Published var isShowingSearchResults: Bool = false
//    @Published var categories: [Category] = []
//    @Published var showingCategories: [Int] = []
//    @Published var searchText: String = ""
//    @Published var searchItems: [SearchItemResponse] = []
////    @Published var lastSearchItems: [SearchItemResponse] = []
////    @Published var lastSearchText: String? = nil
//    @Published var locationPermission: Bool = false
//    @Published var searchTimer: Timer? = nil
//    
//    @Published var currentTapMarker: GMSMarker? = nil
//    private var allFootprints: [FootPrint] = []
//    
//    private var mapView: GMSMapView? = nil
//    private var searchCnt: Int = 0
//    private var lastSearchText: String? = nil
//    private let realm: Realm
//    private let googleApi: GoogleApi
//    
//    override init(_ coordinator: AppCoordinator) {
//        self.realm = R.realm
//        self.locationManager = CLLocationManager()
//        self.locationManager.allowsBackgroundLocationUpdates = true
//        self.googleApi = GoogleApi.instance
//        super.init(coordinator)
//    }
//    
//    func onAppear() {
//        print("onAppear")
//        self.removeCurrentMarker()
//        switch checkLocationPermission() {
//        case .allow:
//            self.locationPermission = true
//            getCurrentLocation()
//            loadCategories()
//        default:
//            self.locationPermission = false
//            self.myLocation = Location(latitude: 0.0, longitude: 0.0)
//            break
//        }
//        if let myLocation = self.myLocation {
//            self.moveCamera(CLLocationCoordinate2D(latitude: myLocation.latitude, longitude: myLocation.longitude))
//        }
//        self.loadAllMarkers()
//        self.loadAllFootprints()
//    }
//    
//    func viewDidLoad() {
//        print("viewDidLoad")
//        switch checkLocationPermission() {
//        case .allow:
//            self.locationPermission = true
//            getCurrentLocation()
//            loadCategories()
//        default:
//            self.locationPermission = false
//            self.myLocation = Location(latitude: 0.0, longitude: 0.0)
//            break
//        }
//        self.loadAllMarkers()
//        self.loadAllFootprints()
//    }
//    
//    private func loadCategories() {
//        print("sandy loadCategories")
//        // 객체 초기화
//        self.categories = []
//        
//        // 모든 객체 얻기
//        self.showingCategories = Defaults.showingCategories
//        let dbCategories = realm.objects(Category.self).sorted(byKeyPath: "tag", ascending: true)
//        for i in dbCategories {
//            self.categories.append(Category(tag: i.tag, name: i.name, pinType: i.pinType.pinType(), pinColor: i.pinColor.pinColor()))
//        }
//    }
//    
//    func onClickCategory(_ category: Category) {
//        self.removeCurrentMarker()
//        if let idx = self.showingCategories.firstIndex(of: category.tag) {
//            self.showingCategories.remove(at: idx)
//        } else {
//            self.showingCategories.append(category.tag)
//        }
//        Defaults.showingCategories = self.showingCategories
//        self.loadAllMarkers()
//    }
//    
////    func onClickSetting() {
////        self.removeCurrentMarker()
////        self.coordinator?.presentSettingView()
////    }
////
////    func onClickFootprintList() {
////        self.removeCurrentMarker()
////        self.coordinator?.presentFootprintListView()
////    }
////
////    func onClickTravelList() {
////        self.removeCurrentMarker()
////        self.coordinator?.presentTravelListView()
////    }
//    
//    override func onClickMenu(_ type: MainMenuType) {
//        self.removeCurrentMarker()
//        super.onClickMenu(type)
//    }
//    
//    private func getCurrentLocation() {
//        if let coor = locationManager.location?.coordinate {
//            let latitude = coor.latitude
//            let longitude = coor.longitude
//            print("위도 :\(latitude), 경도: \(longitude)")
//            //            self.currenLocation = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: latitude, longitude: longitude), span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
//            self.myLocation = Location(latitude: latitude, longitude: longitude)
//        }
//    }
//    
//    private func getSavedData() {
//        // 모든 객체 얻기
//        let footPrints = realm.objects(FootPrint.self)
//        self.annotations.removeAll()
//        for i in footPrints {
//            print(i)
//            annotations.append(Pin(footPrint: i, coordinate: CLLocationCoordinate2D(latitude: i.latitude, longitude: i.longitude)))
//        }
//    }
//    
//    func onClickAnnotation(_ item: Pin) {
//        print("onClickAnnotation: \(item)")
//    }
//    
//    // MAP
//    func initMapView(_ mapView: GMSMapView) {
//        if self.mapView != nil { return }
//        self.mapView = mapView
//    }
//    
//    func loadAllMarkers() {
////        guard let mapView = self.mapView else { return }
//        self.startProgress()
//        
//        self.removeCurrentMarker()
//        for item in self.markerList {
//            removeMarker(marker: item.marker)
//        }
//        self.markerList.removeAll()
//        let footPrints = realm.objects(FootPrint.self)
//            .filter({[weak self] category in
//                self?.showingCategories.firstIndex(of: category.tag) != nil
//            })
//        
//        for footPrint in footPrints {
//            if let category = footPrint.tag.getCategory(), let marker = drawMarker(
//                location: Location(latitude: footPrint.latitude, longitude: footPrint.longitude),
//                category: category) {
//                markerList.append(MarkerItem(marker: marker, footPrint: footPrint))
//            }
//        }
//        self.stopProgress()
//    }
//    
//    
//    func removeMarker(marker: GMSMarker) {
//        marker.map = nil
//    }
//    
//    func onClose() {
//        self.dismiss()
//    }
//    
//    func onTapMarker(_ location: Location) {
//        print("on tap marker")
//        self.removeCurrentMarker()
//        //        drawCurrentMarker(location)
//        self.coordinator?.presentShowFootPrintView(location, onDismiss: {[weak self] in
//            guard let self = self else { return }
//            self.removeCurrentMarker()
//        })
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
//        var message: String = "해당 위치에 마커를 추가하시겠습니까?"
//        if let name = name {
//            message = "\(name)에 마커를 추가하시겠습니까?"
//        }
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
//    }
//    
//    func drawMarker(location: Location, category: Category) -> GMSMarker? {
//        // 마커 생성하기
//        // MARK: mix two images!
//        // reference: https://stackoverflow.com/questions/32006128/how-to-merge-two-uiimages
//        let marker = GMSMarker(position: CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude))
//        
//        let backgroundSize = CGSize(width: 130, height: 130)
//        let itemSize = CGSize(width: 100, height: 100)
//        let itemFinalSize = CGSize(width: 22, height: 22)
//        let markerImage: UIImage? = UIImage(named: category.pinType.pinType().pinWhite)?.resizeImageTo(size: itemSize)
//        var backgroundImage: UIImage? = UIImage(named: "mark_background_black")?.resizeImageTo(size: backgroundSize)
//        backgroundImage = backgroundImage?.withTintColor(category.pinColor.pinColor().pinUIColor, renderingMode: .alwaysTemplate)
//        
//        guard let markerImage = markerImage, let backgroundImage = backgroundImage else { return nil }
//        
//        let backgroundRect = CGRect(x: 0, y: 0, width: backgroundSize.width, height: backgroundSize.height)
//        let itemRect = CGRect(x: (backgroundSize.width - itemSize.width) / 2, y: (backgroundSize.height - itemSize.height) / 2, width: itemSize.width, height: itemSize.height)
//        
//        UIGraphicsBeginImageContext(backgroundSize)
//        backgroundImage.draw(in: backgroundRect, blendMode: .normal, alpha: 1)
//        markerImage.draw(in: itemRect, blendMode: .normal, alpha: 1)
//        
//        let finalMarkerImage: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
//        UIGraphicsEndImageContext()
//        
//        guard let finalMarkerImage = finalMarkerImage?.resizeImageTo(size: itemFinalSize) else { return nil }
//        let finalMarkerImageView = UIImageView(image: finalMarkerImage.withRenderingMode(.alwaysOriginal))
//        marker.iconView = finalMarkerImageView
//        marker.map = self.mapView
//        marker.tracksViewChanges = false
//        marker.isTappable = true
//        
//        return marker
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
//        marker.map = self.mapView
//        marker.tracksViewChanges = false
//        marker.isTappable = true
//        marker.map = self.mapView
//        
//        self.currentTapMarker = marker
//    }
//    
//    func loadAllFootprints() {
//        self.allFootprints = Array(self.realm.objects(FootPrint.self))
//    }
//    
//    func enterSearchText() {
//        let text = self.searchText
//        if text.isEmpty {
//            self.stopRepeatTimer()
//            self.searchText = ""
//            self.lastSearchText = nil
//            return
//        }
//        if !self.isShowingSearchResults {
//            self.isShowingSearchResults = true
//        }
//        print("enter text: \(text)")
//        searchCnt = 0
//        if self.searchTimer == nil {
//            self.startRepeatTimer()
//        }
//    }
//    
//    func onCloseSearchBox() {
//        self.stopRepeatTimer()
//        self.lastSearchText = self.searchText
////        self.lastSearchItems = self.searchItems
//        
////        self.searchText = ""
////        self.searchItems = []
//        self.isShowingSearchResults = false
//    }
//    
//    func onClickSearchCancel() {
//        self.stopRepeatTimer()
//        self.lastSearchText = nil
////        self.lastSearchItems = []
//        
//        self.searchText = ""
//        self.searchItems = []
//    }
//    
//    func onTapSearchBox() {
//        if (isShowingSearchResults == true) || (isShowingSearchResults == false && self.searchItems.isEmpty) {
//            return
//        }
//        isShowingSearchResults = true
//    }
//    
//    private func timerStopAndTask() {
//        if let lastSearchText = self.lastSearchText, lastSearchText == self.searchText {
//            return
//        }
//        self.lastSearchText = self.searchText
//        self.placeSearch(self.searchText)
//    }
//    
//    // https://developers.google.com/maps/documentation/places/ios-sdk/autocomplete#get_place_predictions
//    private func placeSearch(_ text: String) {
//        guard let myLocation = myLocation else { return }
//        let filter = GMSAutocompleteFilter()
//        let searchBound: Double = 2.0
//        let northEastBounds = CLLocationCoordinate2DMake(myLocation.latitude + searchBound, myLocation.longitude + searchBound);
//        let southWestBounds = CLLocationCoordinate2DMake(myLocation.latitude - searchBound, myLocation.longitude - searchBound);
//        filter.locationBias = GMSPlaceRectangularLocationOption(northEastBounds, southWestBounds);
//        
//        let placesClient: GMSPlacesClient = GMSPlacesClient()
//        placesClient.findAutocompletePredictions(fromQuery: text, filter: filter, sessionToken: nil, callback: {[weak self] (results, error) in
//            guard let self = self else {
//                return
//            }
//            if let error = error {
//                print("Autocomplete error: \(error)")
//                self.searchItems.removeAll()
//                return
//            }
//            if let results = results {
//                self.searchItems.removeAll()
//                for result in results {
//                    self.searchItems.append(
//                        SearchItemResponse(
//                            name: result.attributedPrimaryText.string,
//                            fullAddress: result.attributedFullText.string,
//                            secondaryAddress: result.attributedSecondaryText?.string,
//                            placeId: result.placeID,
//                            types: result.types
//                        )
//                    )
//                }
//            }
//        })
//    }
//    
//    func onClickSearchItem(_ item: SearchItemResponse) {
//        self.startProgress()
//        self.googleApi.getGeocoding(item.placeId)
//            .run(in: &self.subscription) {[weak self] results in
//                guard let self = self, let result = results.first else {
//                    self?.stopProgress()
//                    return
//                }
//                let lat: Double = result.geometry.location.lat
//                let lng: Double = result.geometry.location.lng
//                let clLocation: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: lat, longitude: lng)
//                self.stopProgress()
//                self.moveCamera(clLocation)
//                // icon_mark
//                self.drawCurrentMarker(Location(latitude: lat, longitude: lng))
//                self.onCloseSearchBox()
//            } err: {[weak self] err in
//                print("error: \(err)")
//                self?.stopProgress()
//                self?.alert(.ok, title: "정보를 불러올 수 없습니다.")
//            } complete: {
//                print("complete")
//            }
//    }
//    
//    private func moveCamera(_ location: CLLocationCoordinate2D) {
//        self.mapView?.animate(toLocation: location)
//    }
//    
//    func onClickLocationPermission() {
//        self.removeCurrentMarker()
//        self.alert(.yesOrNo, title: "원활한 사용을 위해 위치권한이 필요합니다.", description: "OK를 누르면 권한설정으로 이동합니다.") { isAllow in
//            if isAllow {
//                guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
//                
//                if UIApplication.shared.canOpenURL(url) {
//                    UIApplication.shared.open(url)
//                }
//            }
//        }
//    }
//    
//    func removeCurrentMarker() {
//        if let currentTapMarker = self.currentTapMarker {
//            self.removeMarker(marker: currentTapMarker)
//        }
//    }
//    
//    //MARK: Timer
//    // 반복 타이머 시작
//    private func startRepeatTimer() {
//        searchTimer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(timerTask(timer:)), userInfo: "check permission", repeats: true)
//    }
//    
//    // 반복 타이머 실행, 타이머 돌때 할 작업
//    @objc private func timerTask(timer: Timer) {
//        if timer.userInfo != nil {
//            searchCnt += 1
//            print("timer run : \(searchCnt)")
//            if searchCnt == 4 {
//                stopRepeatTimer()
//                // timer 종료되고 할 작업
//                self.timerStopAndTask()
//            }
//        }
//    }
//    
//    
//    // 반복 타이머 종료
//    private func stopRepeatTimer() {
//        if let timer = searchTimer {
//            print("timer stop!")
//            if timer.isValid {
//                timer.invalidate()
//            }
//            searchTimer = nil
//            searchCnt = 0
//        }
//    }
//}
//
