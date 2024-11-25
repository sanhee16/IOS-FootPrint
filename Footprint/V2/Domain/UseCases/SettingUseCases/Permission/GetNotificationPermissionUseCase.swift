//
//  GetNotificationPermissionUseCase.swift
//  Footprint
//
//  Created by sandy on 11/25/24.
//

import NotificationCenter

class GetNotificationPermissionUseCase {

    func execute() async -> Bool {
        return await withCheckedContinuation { continuation in
            UNUserNotificationCenter.current().getNotificationSettings(completionHandler: { (settings) in
                if settings.authorizationStatus == .authorized {
                    continuation.resume(returning: true)
                } else {
                    continuation.resume(returning: false)
                }
            })
        }
    }
}
