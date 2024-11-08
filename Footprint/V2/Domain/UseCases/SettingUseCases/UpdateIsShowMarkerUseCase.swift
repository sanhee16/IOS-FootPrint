//
//  UpdateIsShowMarkerUseCase.swift
//  Footprint
//
//  Created by sandy on 11/8/24.
//

class UpdateIsShowMarkerUseCase {
    var settingRepository: SettingRepository

    init(settingRepository: SettingRepository) {
        self.settingRepository = settingRepository
    }
    
    func execute(_ isShow: Bool) -> Bool {
        self.settingRepository.updateIsShowMarker(isShow)
        return self.settingRepository.getIsShowMarker()
    }
}
