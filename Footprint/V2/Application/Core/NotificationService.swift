//
//  NotificationService.swift
//  Footprint
//
//  Created by sandy on 11/5/24.
//

import Foundation

final class NotificationService {
    func changeMapStatus(_ status: MapStatus) {
        NotificationCenter.default.post(name: .changeMapStatus, object: "\(status.rawValue)")
    }
    
    func setIsShowTabBar(_ isShow: Bool) {
        NotificationCenter.default.post(name: .isShowTabBar, object: isShow)
    }
}
