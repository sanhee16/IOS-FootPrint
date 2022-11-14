//
//  SplashViewModel.swift
//  Footprint
//
//  Created by Studio-SJ on 2022/10/05.
//


import Foundation
import Combine
import AVFoundation
import Photos
import CoreLocation
import UserNotifications


class SplashViewModel: BaseViewModel {
    private var timerRepeat: Timer?
    private var locationManager: CLLocationManager
    
    override init(_ coordinator: AppCoordinator) {
        self.locationManager = CLLocationManager()
        self.locationManager.allowsBackgroundLocationUpdates = true
        super.init(coordinator)
    }
    
    func onAppear() {
        if !Defaults.launchBefore {
            //MARK: 최초실행 Setting
            Defaults.launchBefore = true
            firstTask()
            locationManager.requestWhenInUseAuthorization()
            self.startRepeatTimer()
        } else {
            self.onStartSplashTimer()
        }
    }
    
    private func firstTask() {
        
    }
    
    
    private func checkCameraPermission() {
       AVCaptureDevice.requestAccess(for: .video, completionHandler: {[weak self] (granted: Bool) in
           if granted {
               print("Camera: 권한 허용")
               self?.stopRepeatTimer()
           } else {
               print("Camera: 권한 거부")
               self?.stopRepeatTimer()
           }
       })
    }
    
    
    func onStartSplashTimer() {
        //TODO: 2초로 변경하기!!
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
            self?.coordinator?.presentMain()
        }
    }
    
    
    // 반복 타이머 시작
    func startRepeatTimer() {
        timerRepeat = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerFireRepeat(timer:)), userInfo: "check permission", repeats: true)
    }
    
    // 반복 타이머 실행
    @objc func timerFireRepeat(timer: Timer) {
        if timer.userInfo != nil {
            let status = checkLocationPermission()
            if status != .notYet {
                let center = UNUserNotificationCenter.current()

                center.getNotificationSettings {[weak self] status in
                    print(status.alertSetting)
                    print(status.authorizationStatus)
                    
                    switch status.authorizationStatus {
                    case .notDetermined: break
                    default:
                        self?.checkCameraPermission()
                    }
                }
            }
        }
    }
    
    
    // 반복 타이머 종료
    func stopRepeatTimer() {
        if let timer = timerRepeat {
            if timer.isValid {
                timer.invalidate()
            }
            timerRepeat = nil
            // timer 종료되고 작업 시작
            onStartSplashTimer()
        }
    }
    
}
