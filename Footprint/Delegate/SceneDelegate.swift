//
//  SceneDelegate.swift
//  FootPrint
//
//  Created by Studio-SJ on 2022/10/05.
//

import UIKit
import SwiftUI
import Combine

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    var appCoordinator: AppCoordinator?
    var subscription = Set<AnyCancellable>()
    let userNotificationCenter = UNUserNotificationCenter.current()
    private var api: Api = Api.instance
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(windowScene: windowScene)
        guard let window = self.window else { return }
        print("scene")
        
        if #available(iOS 13.0, *) {
            window.overrideUserInterfaceStyle = .light
        }
        
        //MARK: Splash Start
        appCoordinator = AppCoordinator(window: window)
        appCoordinator?.startSplash()
        
        (UIApplication.shared.delegate as? AppDelegate)?.appTerminate = {
            print("App Ternimate in Callback")
            self.appCoordinator?.appTerminate() //AppCoordinator의 appTerminate 호출
        }
    }
    // scene이 background로 들어갔을 때 시스템이 자원을 확보하기 위해 disconnect 하려고 할 수 있음.
    // 필요없는 자원은 돌려주는 작업을 진행해야함(디스크나 네트워크로 불러오기 쉬운 데이터는 돌려주고, 재생성이 어려운 데이터는 가지고 있어야 함. 이 작업을 진행하는 곳).
    func sceneDidDisconnect(_ scene: UIScene) {
        print("sceneDidDisconnect")
    }
    
    // scene이 setup되고 화면에 보여지면서 사용될 준비가 완료 된 상태. 즉, inactive -> active로 전활될 때도 불리고, 처음 active 될 때도 불림
    func sceneDidBecomeActive(_ scene: UIScene) {
        print("sceneDidBecomeActive")
    }
    
    // active한 상태에서 inactive 상태로 빠질 때 불려짐(ex. 사용 중 전화가 걸려오는 것 처럼 임시 interruption때문에 발생할 수 있음)
    func sceneWillResignActive(_ scene: UIScene) {
        print("sceneWillResignActive")
        if #available(iOS 10.0, *) { // iOS 버전 10 이상에서 작동
            
        } else {
            NSLog("User iOS Version lower than 13.0. please update your iOS version")
            // iOS 9.0 이하에서는 UILocalNotification 객체를 활용한다.
        }
    }
    
    // 다음 두가지 상황에 호출되는 메소드 : 1. background -> foreground 상태가 되었을 때. 2. 그냥 처음 active상태가 되었을 때
    func sceneWillEnterForeground(_ scene: UIScene) {
        print("sceneWillEnterForeground")
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        print("sceneDidEnterBackground")
    }
}
