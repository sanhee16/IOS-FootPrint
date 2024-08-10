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
    @State private var isShowSplash = true
    
    var body: some Scene {
        WindowGroup {
            if isShowSplash {
                SplashView2(isShowSplash: $isShowSplash)
            } else {
                MainView2()
            }
        }
    }
}
