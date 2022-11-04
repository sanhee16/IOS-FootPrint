//
//  AppCoordinator.swift
//  Footprint
//
//  Created by Studio-SJ on 2022/10/05.
//


import SwiftUI

class AppCoordinator: Coordinator, Terminatable {
    // UIWindow = 화면에 나타나는 View를 묶고, UI의 배경을 제공하고, 이벤트 처리행동을 제공하는 객체 = View들을 담는 컨테이너
    let window: UIWindow
    
    init(window: UIWindow) { // SceneDelegate에서 호출
        self.window = window
        super.init() // Coordinator init
        let navigationController = UINavigationController()
        self.navigationController = navigationController // Coordinator의 navigationController
        self.window.rootViewController = navigationController // window의 rootViewController
        window.makeKeyAndVisible()
    }
    
    // Terminatable
    func appTerminate() {
        print("app Terminate")
        for vc in self.childViewControllers {
            print("terminate : \(type(of: vc))")
            (vc as? Terminatable)?.appTerminate()
        }
        if let navigation = self.navigationController as? UINavigationController {
            for vc in navigation.viewControllers {
                (vc as? Terminatable)?.appTerminate()
            }
        } else {
            
        }
        print("terminate : \(type(of: self.navigationController))")
        (self.navigationController as? Terminatable)?.appTerminate()
    }
    
    func startSplash() {
        let vc = SplashView.vc(self)
        self.present(vc, animated: true)
    }
    
    func presentMain() {
        let vc = MainView.vc(self)
        self.present(vc, animated: true)
    }
    
    func presentAddFootprintView() {
        let vc = AddFootprintView.vc(self)
        self.present(vc, animated: true)
    }
}
