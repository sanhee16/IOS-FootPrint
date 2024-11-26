//
//  GetIsShowSearchBarUseCase.swift
//  Footprint
//
//  Created by sandy on 11/26/24.
//

class GetIsShowSearchBarUseCase {
    var settingRepository: SettingRepository

    init(settingRepository: SettingRepository) {
        self.settingRepository = settingRepository
    }
    
    func execute() -> Bool {
        self.settingRepository.getIsShowSearchBar()
    }
}
