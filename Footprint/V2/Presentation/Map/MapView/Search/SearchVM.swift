//
//  SearchVM.swift
//  Footprint
//
//  Created by sandy on 12/21/24.
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

class SearchVM: ObservableObject {
    @Injected(\.searchPlaceUseCase) private var searchPlaceUseCase
    @Injected(\.getLocationUseCase) private var getLocationUseCase
    @Published var searchItems: [SearchEntity] = []
    @Published var searchText: String = ""
    @Published var location: Location
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
    
    func getLocation(_ placeId: String, onDone: @escaping (Location?) -> ()) {
        Task {
            switch await self.getLocationUseCase.execute(placeId) {
            case .success(let location):
                onDone(location)
            case .failure(let error):
                print(error)
                onDone(nil)
            }
        }
    }
    
    @MainActor
    // Typing Text
    func onTypeText(_ onDone: @escaping (SearchStatus) -> ()) {
        if self.searchText.isEmpty {
            onDone(.none)
            return
        }
        self.resetSearchItem()
        self.onSearchText { status in
            onDone(status)
        }
    }
    
    // Search Text
    private func onSearchText(_ onDone: @escaping (SearchStatus) -> ()) {
        if self.searchText.isEmpty {
            onDone(.none)
            return
        }
        
        DispatchQueue.main.async {[weak self] in
            guard let self = self else { return }
            Task {
                self.searchItems = await self.searchPlaceUseCase.execute(self.searchText, location: self.location, sessionToken: self.sessionToken)
                onDone(.finish)
            }
        }
    }
    
    @MainActor
    // remove all, cacnel search
    func onCancel(_ onDone: @escaping (SearchStatus) -> ()) {
        onDone(.none)
        self.searchItems.removeAll()
        self.searchText.removeAll()
    }
}

