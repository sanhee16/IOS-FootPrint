//
//  UpdateFootprintSortTypeUseCase.swift
//  Footprint
//
//  Created by sandy on 11/18/24.
//

class UpdateFootprintSortTypeUseCase {
    var settingRepository: SettingRepository

    init(settingRepository: SettingRepository) {
        self.settingRepository = settingRepository
    }
    
    func execute(_ type: FootprintSortType) -> FootprintSortType {
        self.settingRepository.updateFootprintSortType(type.rawValue)
        return FootprintSortType(rawValue: self.settingRepository.getFootprintSortType()) ?? .latest
    }
}

