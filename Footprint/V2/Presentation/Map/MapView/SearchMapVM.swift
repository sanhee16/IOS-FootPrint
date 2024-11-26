//
//  SearchMapVM.swift
//  Footprint
//
//  Created by sandy on 11/26/24.
//

import Combine
import Factory
import CoreLocation
import GooglePlaces

enum SearchStatus {
    case none
    case searching
    case finish
}

class SearchMapVM: ObservableObject {
    @Injected(\.searchPlaceUseCase) var searchPlaceUseCase
    @Published var searchItems: [SearchEntity] = []
    @Published var searchText: String = ""
    @Published var location: Location
    @Published var searchStatus: SearchStatus = .none
    private let timerManager: TimerManager
    let sessionToken = GMSAutocompleteSessionToken()
    
    
    init() {
        timerManager = TimerManager()
        
        if let coor = CLLocationManager().location?.coordinate {
            let latitude = coor.latitude
            let longitude = coor.longitude
            self.location = Location(latitude: latitude, longitude: longitude)
        } else {
            self.location = Location(latitude: 12.0, longitude: 25.0)
        }
        resetSearchItem()
//        timerManager.setTask(task: self.onSearchText)
    }
    
    private func resetSearchItem() {
        searchItems = [
            SearchEntity(name: "temp name", fullAddress: "temp full address for skeleton", placeId: "", types: []),
            SearchEntity(name: "temp name", fullAddress: "temp full address for skeleton", placeId: "", types: []),
            SearchEntity(name: "temp name", fullAddress: "temp full address for skeleton", placeId: "", types: [])
        ]
    }
    
    @MainActor
    // Typing Text
    func onTypeText() {
        if self.searchText.isEmpty {
//            timerManager.stopTimer()
            self.searchStatus = .none
            return
        }
        self.resetSearchItem()
        self.searchStatus = .searching
//        timerManager.restartTimer()
        self.onSearchText()
    }
    
    // Search Text
    private func onSearchText() {
        if self.searchText.isEmpty {
//            timerManager.stopTimer()
            self.searchStatus = .none
            return
        }
        
        DispatchQueue.main.async {[weak self] in
            guard let self = self else { return }
            Task {
                self.searchItems = await self.searchPlaceUseCase.execute(self.searchText, location: self.location, sessionToken: self.sessionToken)
                self.searchStatus = .finish
            }
        }
    }
    
    @MainActor
    // remove all, cacnel search
    func onCancel() {
//        timerManager.stopTimer()
        self.searchStatus = .none
        self.searchItems.removeAll()
        self.searchText.removeAll()
    }
}
