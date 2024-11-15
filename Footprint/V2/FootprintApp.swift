//
//  FootprintApp.swift
//  Footprint
//
//  Created by sandy on 8/8/24.
//

import SwiftUI
import SDSwiftUIPack

@main
struct FootprintApp: App {
    @UIApplicationDelegateAdaptor private var appDelegate: AppDelegate
    @State private var isShowMain = false
    
    var body: some Scene {
        WindowGroup {
            if isShowMain {
                MainView2()
            } else {
                SplashView2(isShowMain: $isShowMain)
            }
        }
    }
}
