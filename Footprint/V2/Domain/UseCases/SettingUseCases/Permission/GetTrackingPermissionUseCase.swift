//
//  GetTrackingPermissionUseCase.swift
//  Footprint
//
//  Created by sandy on 11/25/24.
//

import AppTrackingTransparency

class GetTrackingPermissionUseCase {
    
    func execute() async -> Bool {
        return await withCheckedContinuation { continuation in
            ATTrackingManager.requestTrackingAuthorization { status in
                // 권한 상태에 따른 결과를 continuation에 전달
                switch status {
                case .authorized:
                    continuation.resume(returning: true)
                default:
                    continuation.resume(returning: false)
                }
            }
        }
    }
}
