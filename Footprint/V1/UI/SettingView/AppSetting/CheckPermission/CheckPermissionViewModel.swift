//
//  CheckPermissionViewModel.swift
//  Footprint
//
//  Created by sandy on 2022/12/07.
//

import Foundation
import Combine
import AVFoundation
import Photos
import CoreLocation
import UserNotifications
import RealmSwift
import UIKit
import AppTrackingTransparency
import AdSupport


enum PermissionType {
    case location
//    case camera
    case tracking
    case photo
    case notification
    
    var text: String {
        switch self {
        case .location: return "permission_location".localized()
//        case .camera: return "permission_camera".localized()
        case .tracking: return "permission_tracking".localized()
        case .photo: return "permission_photo".localized()
        case .notification: return "permission_notification".localized()
        }
    }
}

class CheckPermissionViewModel: BaseViewModelV1 {
    @Published var photoPermission: Bool = false
    @Published var locationPermission: Bool = false
    @Published var trackingPermission: Bool = false
//    @Published var cameraPermission: Bool = false
    @Published var notiPermission: Bool = false
    
    override init(_ coordinator: AppCoordinatorV1) {
        super.init(coordinator)
    }
    
    func onAppear() {
        DispatchQueue.main.async {[weak self] in
            guard let self = self else { return }
//            self.checkCameraPermission()
            self.checkPhotoPermission()
            self.checkTrackingPermission()
            //            self.checkLocationPermission()
            self.checkNotiPermission()
        }
    }
    
    func onClose() {
        self.dismiss(animated: false)
    }
    
    func onClickOffPermission(_ type: PermissionType) {
        switch type {
        case .location:
            let locationManager: CLLocationManager = CLLocationManager()
            locationManager.allowsBackgroundLocationUpdates = false
            locationManager.requestWhenInUseAuthorization()
        case .tracking:
            checkTrackingPermission()
        case .photo:
            PHPhotoLibrary.requestAuthorization {[weak self] status in
                self?.onAppear()
            }
        case .notification:
            self.openAppSetting()
        default: self.openAppSetting()
        }
    }
    
    func openAppSetting() {
        guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
        
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }
    
    private func checkTrackingPermission() {
        ATTrackingManager.requestTrackingAuthorization {[weak self] status in
            switch status {
            case .authorized:
                self?.trackingPermission = true
                print(ASIdentifierManager.shared().advertisingIdentifier)
            case .denied:
                self?.trackingPermission = false
            case .notDetermined:
                self?.trackingPermission = false
            case .restricted:
                self?.trackingPermission = false
            @unknown default:
                self?.trackingPermission = false
            }
        }

    }
    
    private func checkPhotoPermission() {
        switch PHPhotoLibrary.authorizationStatus() {
        case .authorized:
            self.photoPermission = true
            break
        default:
            self.photoPermission = false
            break
        }
    }
    
    private func checkNotiPermission() {
        let currentNotification = UNUserNotificationCenter.current()
        currentNotification.getNotificationSettings(completionHandler: {[weak self] (settings) in
            guard let self = self else { return }
            if settings.authorizationStatus == .authorized {
                DispatchQueue.main.async {[weak self] in
                    self?.notiPermission = true
                }
            } else {
                DispatchQueue.main.async {[weak self] in
                    self?.notiPermission = false
                }
            }
        })
    }
}
