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
//    @StateObject private var mapStatusVM: MapStatusVM = MapStatusVM()
    
    @State private var selectedIndex: Int = 0
    
    
    var body: some View {
        NavigationStack(path: $coordinator.paths) {
            VStack(alignment: .leading, spacing: 0) {
                
//                EditNoteView(
//                    output: coordinator.editNoteOutput,
//                    location: Location(latitude: 0.0, longitude: 0.0),
//                    type: .create
//                )
//
                switch $tabBarService.currentTab.wrappedValue {
                case .map:
                    MapView2(output: coordinator.mapOutput)
//                        .environmentObject(mapStatusVM)
                case .footprints:
                    FootprintListViewV2(output: coordinator.footprintListViewOutput)
                case .trip:
                    TripListView(output: coordinator.tripListViewOutput)
                default:
                    VStack {
                        Spacer()
                    }
                }
                if $tabBarService.isShowTabBar.wrappedValue {
                    MainMenuBar(current: $tabBarService.currentTab.wrappedValue) { type in
                        tabBarService.onTab(type)
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
