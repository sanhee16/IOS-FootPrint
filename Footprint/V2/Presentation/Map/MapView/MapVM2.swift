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
import Factory

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
    @Injected(\.getIsShowMarkerUseCase) var getIsShowMarkerUseCase
    @Injected(\.getIsShowSearchBarUseCase) var getIsShowSearchBarUseCase
    @Injected(\.updateIsShowMarkerUseCase) var updateIsShowMarkerUseCase
    @Injected(\.temporaryNoteService) var temporaryNoteService
    @Injected(\.loadNotesUseCaseWithAddress) var loadNotesUseCaseWithAddress
    @Injected(\.loadNoteUseCaseWithId) var loadNoteUseCaseWithId
    
    private var locationManager: CLLocationManager
    @Published var isShowAds: Bool = false
    @Published var annotations: [Pin] = []
    
    @Published var myLocation: Location? = nil
    @Published var markerList: [MarkerItem] = []
    
    @Published var isShowingSearchResults: Bool = false
//    @Published var searchText: String = ""
//    @Published var searchItems: [SearchItemResponse] = []
    @Published var locationPermission: Bool = false
//    @Published var searchTimer: Timer? = nil
    @Published var isGettingLocation: Bool = true
    
    @Published var selectedMarker: GMSMarker? = nil
    @Published var centerMarkerStatus: MarkerStatus = .stable
    @Published var centerAddress: String = ""
    
    @Published var isShowMarkers: Bool = true
    @Published var isShowSearchBar: Bool = true
    
    @Published var isLoading: Bool = false
    
    var centerPosition: CLLocationCoordinate2D? = nil
    
    private var searchCnt: Int = 0
    private var lastSearchText: String? = nil
    private let googleApi: GoogleApi1
    
    
    override init() {
        self.locationManager = CLLocationManager()
        self.locationManager.allowsBackgroundLocationUpdates = false
        self.googleApi = GoogleApi1.instance
        super.init()
        
        self.isShowMarkers = getIsShowMarkerUseCase.execute()
        self.isShowSearchBar = getIsShowSearchBarUseCase.execute()
        
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
    
    func toggleIsShowMarker() {
        self.isShowMarkers = updateIsShowMarkerUseCase.execute(!self.isShowMarkers)
    }
    
    //MARK: temporary note
    func updateTempLocation(_ location: Location, address: String) -> TemporaryNote? {
        self.temporaryNoteService.updateTempLocation(address: address, location: location)
    }
    
    func updateTempNote(_ id: String) {
        self.temporaryNoteService.updateTempNote(id)
    }
    
    func clearFootprint() {
        self.temporaryNoteService.clear()
    }
    
    func getMultiNoteAddress(_ id: String, onDone: @escaping (String?) -> ()) {
        guard let note = self.loadNoteUseCaseWithId.execute(id) else {
            onDone(nil)
            return
        }
        onDone(note.address)
        return
    }
}
