//
//  PermissionService.swift
//  Footprint
//
//  Created by sandy on 8/24/24.
//

import Foundation
import UIKit
import Photos

class PermissionService {
    init() {
        
    }
    
    
    func photoPermissionCheck(_ callback: @escaping (Bool)->()) {
        let photoAuthStatus = PHPhotoLibrary.authorizationStatus()
        switch photoAuthStatus {
        case .notDetermined:
            print("권한 승인을 아직 하지 않음")
            PHPhotoLibrary.requestAuthorization() { status in
                switch status {
                case .denied:
                    print("거부됨")
                    callback(false)
                    break
                case .authorized:
                    print("승인됨")
                    callback(true)
                    break
                default:
                    callback(false)
                    break
                }
            }
        case .restricted:
            print("권한을 부여할 수 없음")
            callback(false)
            break
        case .denied:
            print("거부됨")
            callback(false)
            break
        case .authorized:
            print("승인됨")
            callback(true)
            break
        case .limited:
            print("limited")
            callback(false)
            break
        @unknown default:
            print("unknown default")
            callback(false)
            break
        }
    }

}
