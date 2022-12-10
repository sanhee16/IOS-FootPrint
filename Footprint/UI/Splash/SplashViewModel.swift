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
import RealmSwift


class SplashViewModel: BaseViewModel {
    private var timerRepeat: Timer?
    private var locationManager: CLLocationManager
    private let realm: Realm
    
    override init(_ coordinator: AppCoordinator) {
        self.locationManager = CLLocationManager()
        self.locationManager.allowsBackgroundLocationUpdates = true
        self.realm = try! Realm()
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
        try! realm.write {
            // 혹시 모르니까 다 지워버릴 것
            self.realm.deleteAll()
            let categories: [Category] = [
                Category(tag: 0, name: "기본", pinType: .star, pinColor: PinColor.pin0),
                Category(tag: 1, name: "맛집", pinType: .restaurant, pinColor: PinColor.pin1),
                Category(tag: 2, name: "술집", pinType: .wine, pinColor: PinColor.pin2),
                Category(tag: 3, name: "빵집", pinType: .bread, pinColor: PinColor.pin3),
                Category(tag: 4, name: "디저트", pinType: .cake, pinColor: PinColor.pin4),
                Category(tag: 5, name: "운동", pinType: .exercise, pinColor: PinColor.pin5),
                Category(tag: 6, name: "카페", pinType: .exercise, pinColor: PinColor.pin6)
            ]
            var showingCategories = Defaults.showingCategories

            for category in categories {
                showingCategories.append(category.tag)
                realm.add(category)
            }
            Defaults.showingCategories = showingCategories
        }
    }
    
    
    private func photoPermissionCheck() {
        PHPhotoLibrary.requestAuthorization() { status in
            switch status {
            case .denied:
                print("거부됨")
                self.stopRepeatTimer()
                break
            case .authorized:
                print("승인됨")
                self.stopRepeatTimer()
                break
            default:
                self.stopRepeatTimer()
                break
            }
        }
    }
    
    private func checkCameraPermission() {
       AVCaptureDevice.requestAccess(for: .video, completionHandler: {[weak self] (granted: Bool) in
           if granted {
               print("Camera: 권한 허용")
               self?.photoPermissionCheck()
           } else {
               print("Camera: 권한 거부")
               self?.photoPermissionCheck()
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
