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
    
    @Published var isLoading: Bool = false
    
    var centerPosition: CLLocationCoordinate2D? = nil
    private var allFootprints: [FootPrint] = []
    
    private var searchCnt: Int = 0
    private var lastSearchText: String? = nil
//    private let realm: Realm
    private let googleApi: GoogleApi
    
    
    override init() {
        print("[SD] init")
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
    }
    
    func onAppear() {
        self.isLoading = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.001, execute: {
            self.isLoading = false
        })
    }
    
    
    
    
    
    //MARK: Timer
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
        
    private func timerStopAndTask() {
        if let lastSearchText = self.lastSearchText, lastSearchText == self.searchText {
            return
        }
        self.lastSearchText = self.searchText
        self.placeSearch(self.searchText)
    }
    
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
