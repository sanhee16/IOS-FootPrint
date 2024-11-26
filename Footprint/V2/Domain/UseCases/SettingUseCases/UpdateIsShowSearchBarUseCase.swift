//
//  UpdateIsShowSearchBarUseCase.swift
//  Footprint
//
//  Created by sandy on 11/26/24.
//

class UpdateIsShowSearchBarUseCase {
    var settingRepository: SettingRepository

    init(settingRepository: SettingRepository) {
        self.settingRepository = settingRepository
    }
    
    func execute(_ isShow: Bool) -> Bool {
        self.settingRepository.updateIsShowSearchBar(isShow)
        return self.settingRepository.getIsShowSearchBar()
    }
}

