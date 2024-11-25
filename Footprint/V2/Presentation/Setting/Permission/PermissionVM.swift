//
//  PermissionVM.swift
//  Footprint
//
//  Created by sandy on 11/25/24.
//

import Combine
import Factory

class PermissionVM: ObservableObject {
    @Published var isOnLocationPermission: Bool = false
    @Published var isOnTrackingPermission: Bool = false
    @Published var isOnPhotoPermission: Bool = false
    @Published var isOnNotificationPermission: Bool = false
}


