//
//  MainView2.swift
//  Footprint
//
//  Created by sandy on 8/8/24.
//

import SwiftUI
import SDSwiftUIPack
import Kingfisher
import Factory

struct MainView2: View {
    @StateObject private var coordinator: Coordinator = Coordinator()
    @StateObject private var vm: MainVM2 = MainVM2()
    @State private var selectedIndex: Int = 0
    @State private var currentTab: MainMenuType = .map
    
    var body: some View {
        NavigationStack(path: $coordinator.paths) {
            VStack(alignment: .leading, spacing: 0) {
                MapView2(output: coordinator.mapOutput)
                
                MainMenuBar(current: $currentTab.wrappedValue) { type in
                    
                }
            }
            .navigationBarBackButtonHidden()
            .navigationDestination(for: Destination.self) { destination in
                coordinator.moveToDestination(destination: destination)
            }
        }
    }
}
