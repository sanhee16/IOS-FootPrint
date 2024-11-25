//
//  GetPhotoPermissionUseCase.swift
//  Footprint
//
//  Created by sandy on 11/25/24.
//

import Photos

class GetPhotoPermissionUseCase {
    func execute() -> Bool {
        switch PHPhotoLibrary.authorizationStatus() {
        case .authorized:
            return true
        default:
            return false
        }
    }
}
