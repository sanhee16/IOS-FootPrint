//
//  GetFootprintSortTypeUseCase.swift
//  Footprint
//
//  Created by sandy on 11/18/24.
//

class GetFootprintSortTypeUseCase {
    var settingRepository: SettingRepository

    init(settingRepository: SettingRepository) {
        self.settingRepository = settingRepository
    }
    
    func execute() -> FootprintSortType {
        FootprintSortType(rawValue: self.settingRepository.getFootprintSortType()) ?? .latest
    }
}
