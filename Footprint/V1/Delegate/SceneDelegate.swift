//
//  SceneDelegate.swift
//  FootPrint
//
//  Created by Studio-SJ on 2022/10/05.
// 개념: https://sueaty.tistory.com/134

import UIKit
import SwiftUI
import SDSwiftUIPack
import Combine
import CoreLocation

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    var appCoordinator: AppCoordinator?
    var subscription = Set<AnyCancellable>()
    let userNotificationCenter = UNUserNotificationCenter.current()
    private var api: CommonApi = CommonApi.instance
    
    /*
     - UISceneSession lifecycle에서 제일 처음 불리는 메소드
     - 첫 content view, 새로운 UIWindow를 생성하고 window의 rootViewController를 설정
     - 첫 view를 만드는데 쓰이기도 하지만 과거에 disconnected 된 UI를 되돌릴 때도 쓰기도 함
     */
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        print("scene")
        
        // 새로운 UIWindow 생성
        // 여기서 window는 사용자가 보는 window가 아니라 app이 작동하는 viewport를 나타냄
        window = UIWindow(windowScene: windowScene)
        guard let window = self.window else { return }
        
        if #available(iOS 13.0, *) {
            window.overrideUserInterfaceStyle = .light
        }
        
        //MARK: Splash Start -> 첫 content view 생성
        appCoordinator = AppCoordinator(window: window)
        appCoordinator?.startSplash()
        
        (UIApplication.shared.delegate as? AppDelegate)?.appTerminate = {
            print("App Ternimate in Callback")
            self.appCoordinator?.appTerminate() //AppCoordinator의 appTerminate 호출
        }
    }
    
    /*
     scene이 background로 들어갔을 때 시스템이 자원을 확보하기 위해 disconnect 하려고 할 수 있음(앱을 종료시킨 것과는 다르구, session에서 끊어지는 것).
     필요없는 자원은 돌려주는 작업을 진행해야함(디스크나 네트워크로 불러오기 쉬운 데이터는 돌려주고, 재생성이 어려운 데이터는 가지고 있어야 함. 이 작업을 진행하는 곳).
     */
    func sceneDidDisconnect(_ scene: UIScene) {
        print("sceneDidDisconnect")
    }
    
    /*
     scene이 setup되고 화면에 보여지면서 사용될 준비가 완료 된 상태. 즉, inactive -> active로 전활될 때도 불리고, 처음 active 될 때도 불림
     */
    func sceneDidBecomeActive(_ scene: UIScene) {
        print("sceneDidBecomeActive")
        switch CLLocationManager().authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            C.permissionLocation = true
            break
        default:
            C.permissionLocation = false
            break
        }
    }
    
    /*
     active한 상태에서 inactive 상태로 빠질 때 불려짐(ex. 사용 중 전화가 걸려오는 것 처럼 임시 interruption때문에 발생할 수 있음)
     */
    func sceneWillResignActive(_ scene: UIScene) {
        print("sceneWillResignActive")
        if #available(iOS 10.0, *) { // iOS 버전 10 이상에서 작동
            
        } else {
            NSLog("User iOS Version lower than 13.0. please update your iOS version")
            // iOS 9.0 이하에서는 UILocalNotification 객체를 활용한다.
        }
    }
    /*
     다음 두가지 상황에 호출되는 메소드(scene이 foreground로 전환될 때 불리는 데 그 경우가 2가지가 있음) :
     1. background -> foreground 상태가 되었을 때.
     2. 그냥 처음 active상태가 되었을 때
     */
    func sceneWillEnterForeground(_ scene: UIScene) {
        print("sceneWillEnterForeground")
    }
    
    /*
     foreground에서 background로 전환 될 때 불림
     다음에 다시 foreground에 돌아 올 때 복원할 수 있도록 state 정보를 저장하거나, 데이터를 저장, 공유 자원 돌려주는 등의 일을 하면 됨.
     */
    func sceneDidEnterBackground(_ scene: UIScene) {
        print("sceneDidEnterBackground")
    }
}
