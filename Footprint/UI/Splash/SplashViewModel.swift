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

class SplashViewModel: BaseViewModel {
    private var timerRepeat: Timer?
    
    override init(_ coordinator: AppCoordinator) {
        super.init(coordinator)
    }
    
    func onAppear() {
        if !Defaults.launchBefore {
            //MARK: 최초실행 Setting
            Defaults.launchBefore = true
            checkCameraPermission()
        } else {
            self.onStartSplashTimer()
        }
    }
    
    private func checkCameraPermission() {
       AVCaptureDevice.requestAccess(for: .video, completionHandler: {[weak self] (granted: Bool) in
           if granted {
               print("Camera: 권한 허용")
               self?.onStartSplashTimer()
           } else {
               print("Camera: 권한 거부")
               self?.onStartSplashTimer()
           }
       })
    }
    
    func onStartSplashTimer() {
        //TODO: 2초로 변경하기!!
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
            self?.coordinator?.presentMain()
        }
    }
}
