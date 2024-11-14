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
    @StateObject private var tabBarService: TabBarService = TabBarService()
    @StateObject private var mapStatusVM: MapStatusVM = MapStatusVM()
    
    @State private var selectedIndex: Int = 0
    @State private var currentTab: MainMenuType = .map
    
    
    var body: some View {
        NavigationStack(path: $coordinator.paths) {
            VStack(alignment: .leading, spacing: 0) {
                
//                EditNoteView(
//                    output: coordinator.editNoteOutput,
//                    location: Location(latitude: 0.0, longitude: 0.0),
//                    type: .create
//                )
//
                switch $currentTab.wrappedValue {
                case .map:
                    MapView2(output: coordinator.mapOutput)
                        .environmentObject(mapStatusVM)
                case .travel:
                    TripListView(output: coordinator.tripListViewOutput)
                default:
                    VStack {
                        Spacer()
                    }
                }
                if $tabBarService.isShowTabBar.wrappedValue {
                    MainMenuBar(current: $currentTab.wrappedValue) { type in
                        $currentTab.wrappedValue = type
                    }
                }
            }
            .navigationBarBackButtonHidden()
            .navigationDestination(for: Destination.self) { destination in
                coordinator.moveToDestination(destination: destination)
            }
        }
        .environmentObject(tabBarService)
    }
}
