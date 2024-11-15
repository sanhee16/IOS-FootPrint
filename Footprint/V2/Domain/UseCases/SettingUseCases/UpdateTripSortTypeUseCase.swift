//
//  UpdateTripSortTypeUseCase.swift
//  Footprint
//
//  Created by sandy on 11/15/24.
//

class UpdateTripSortTypeUseCase {
    var settingRepository: SettingRepository

    init(settingRepository: SettingRepository) {
        self.settingRepository = settingRepository
    }
    
    func execute(_ type: TripSortType) -> TripSortType {
        self.settingRepository.updateTripSortType(type.rawValue)
        return TripSortType(rawValue: self.settingRepository.getTripSortType()) ?? .latest
    }
}
