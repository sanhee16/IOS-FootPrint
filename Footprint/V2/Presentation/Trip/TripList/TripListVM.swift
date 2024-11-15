//
//  TripListVM.swift
//  Footprint
//
//  Created by sandy on 11/12/24.
//

import Combine
import Factory

enum TripSortType: Int {
    case latest = 0 // 최신순
    case earliest // 오래된순
    case more // 발자국 많은 순
    case less // 발자국 적은 순
    
    var text: String {
        switch self {
        case .latest:
            return "최신순"
        case .earliest:
            return "오래된순"
        case .more:
            return "발자국 많은 순"
        case .less:
            return "발자국 적은 순"
        }
    }
}

class TripListVM: ObservableObject {
    @Injected(\.loadTripsUseCase) var loadTripsUseCase
    @Injected(\.getTripSortTypeUseCase) var getTripSortTypeUseCase
    @Injected(\.updateTripSortTypeUseCase) var updateTripSortTypeUseCase
    @Published var trips: [TripEntity] = []
    let sortTypes: [TripSortType] = [.latest, .earliest, .more, .less]
    @Published var sortType: TripSortType = .latest
    
    init() {
        self.sortType = self.getTripSortTypeUseCase.execute()
    }
    
    func loadData() {
        self.trips = self.loadTripsUseCase.execute()
    }
    
    func onSelectSortType(_ sortType: TripSortType) {
        self.sortType = self.updateTripSortTypeUseCase.execute(sortType)
    }
}
