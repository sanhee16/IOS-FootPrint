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

class CheckPermissionViewModel: BaseViewModel {
    @Published var photoPermission: Bool = false
    @Published var locationPermission: Bool = false
    @Published var cameraPermission: Bool = false
    @Published var notiPermission: Bool = false
    
    override init(_ coordinator: AppCoordinator) {
        super.init(coordinator)
    }
    
    func onAppear() {
        DispatchQueue.main.async {[weak self] in
            guard let self = self else { return }
            self.checkCameraPermission()
            self.checkPhotoPermission()
            self.checkLocationPermission()
            self.checkNotiPermission()
        }
    }
    
    func onClose() {
        self.dismiss(animated: false)
    }
    
    func openAppSetting() {
        guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
        
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }
    
    private func checkCameraPermission() {
        switch AVCaptureDevice.authorizationStatus(for: AVMediaType.video) {
        case .notDetermined:
            print("권한 요청 전 상태")
            self.cameraPermission = false
            break
        case .authorized:
            print("권한 허용 상태")
            self.cameraPermission = true
            break
        case .denied:
            print("권한 거부 상태")
            self.cameraPermission = false
            break
        case .restricted:
            print("액세스 불가 상태")
            self.cameraPermission = false
            break
        @unknown default:
            print("unknown default")
            self.cameraPermission = false
            break
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
    
    
    private func checkLocationPermission() {
        switch CLLocationManager().authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            self.locationPermission = true
            break
        default:
            self.locationPermission = false
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
