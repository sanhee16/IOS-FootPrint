//
//  GetIsShowMarkerUseCase.swift
//  Footprint
//
//  Created by sandy on 11/8/24.
//

class GetIsShowMarkerUseCase {
    var settingRepository: SettingRepository

    init(settingRepository: SettingRepository) {
        self.settingRepository = settingRepository
    }
    
    func execute() -> Bool {
        self.settingRepository.getIsShowMarker()
    }
}
