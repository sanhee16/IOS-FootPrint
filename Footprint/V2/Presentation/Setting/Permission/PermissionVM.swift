//
//  PermissionVM.swift
//  Footprint
//
//  Created by sandy on 11/25/24.
//

import Combine
import Factory
import UIKit
import Foundation

class PermissionVM: ObservableObject {
    @Injected(\.getPhotoPermissionUseCase) var getPhotoPermissionUseCase
    @Injected(\.getLocationPermissionUseCase) var getLocationPermissionUseCase
    @Injected(\.getTrackingPermissionUseCase) var getTrackingPermissionUseCase
    @Injected(\.getNotificationPermissionUseCase) var getNotificationPermissionUseCase
    
    @Published var isAllowPhotoPermission: Bool = false
    @Published var isAllowLocationPermission: Bool = false
    @Published var isAllowTrackingPermission: Bool = false
    @Published var isAllowNotificationPermission: Bool = false
    
    init() {
        self.addObserver()
        Task {
            await self.updatePermissionStatus()
        }
    }
    
    deinit {
        // 옵저버 해제
        NotificationCenter.default.removeObserver(self)
    }
    
    func addObserver() {
        // 포그라운드 감지
        NotificationCenter.default.addObserver(self, selector: #selector(updatePermissionStatus), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    @MainActor
    @objc
    func updatePermissionStatus() async {
        self.isAllowPhotoPermission = self.getPhotoPermissionUseCase.execute()
        self.isAllowLocationPermission = self.getLocationPermissionUseCase.execute()
        self.isAllowTrackingPermission = await self.getTrackingPermissionUseCase.execute()
        self.isAllowNotificationPermission = await self.getNotificationPermissionUseCase.execute()
    }
    
    func moveToApplicationSetting() {
        guard let url = URL(string: UIApplication.openSettingsURLString) else { return }

        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }
}
