//
//  GetTripSortTypeUseCase.swift
//  Footprint
//
//  Created by sandy on 11/15/24.
//

class GetTripSortTypeUseCase {
    var settingRepository: SettingRepository

    init(settingRepository: SettingRepository) {
        self.settingRepository = settingRepository
    }
    
    func execute() -> TripSortType {
        TripSortType(rawValue: self.settingRepository.getTripSortType()) ?? .latest
    }
}
