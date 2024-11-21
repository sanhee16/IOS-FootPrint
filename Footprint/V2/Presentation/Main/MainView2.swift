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
    @StateObject private var mapCoordinator: MapCoordinator = MapCoordinator()
    @StateObject private var footprintCoordinator: FootprintCoordinator = FootprintCoordinator()
    @StateObject private var tripCoordinator: TripCoordinator = TripCoordinator()
    
    @StateObject private var vm: MainVM2 = MainVM2()
    @StateObject private var tabBarService: TabBarVM = TabBarVM()
    
    @State private var currentTab: Int = 0
    
    private let ICON_SIZE: CGFloat = 24.0
    private let ITEM_WIDTH: CGFloat = UIScreen.main.bounds.width / 4
    private let ITEM_HEIGHT: CGFloat = 64.0
    
    init() {
        UITabBar.appearance().barTintColor = .clear
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            TabView(selection: $currentTab, content:  {
                MapView2(output: mapCoordinator.mapOutput)
                    .tabItem {
                        drawTabItem(MainMenuType.map)
                    }
                    .tag(MainMenuType.map.rawValue)
                    .environmentObject(mapCoordinator)
                    .toolbar($tabBarService.isShowTabBar.wrappedValue ? .visible : .hidden, for: .tabBar)
                
                FootprintListViewV2(output: footprintCoordinator.footprintListViewOutput)
                    .tabItem {
                        drawTabItem(MainMenuType.footprints)
                    }
                    .tag(MainMenuType.footprints.rawValue)
                    .environmentObject(footprintCoordinator)
                    .toolbar($tabBarService.isShowTabBar.wrappedValue ? .visible : .hidden, for: .tabBar)
                
                TripListView(output: tripCoordinator.tripListViewOutput)
                    .tabItem {
                        drawTabItem(MainMenuType.trip)
                    }
                    .tag(MainMenuType.trip.rawValue)
                    .environmentObject(tripCoordinator)
                    .toolbar($tabBarService.isShowTabBar.wrappedValue ? .visible : .hidden, for: .tabBar)
            })
            .tint(.cont_primary_mid)
        }
        .environmentObject(tabBarService)
        .onAppear {
            UITabBar.appearance().barTintColor = .clear
            UITabBar.appearance().backgroundColor = Color.bg_bgb.uiColor
            
            let standardAppearance = UITabBarAppearance()
            standardAppearance.backgroundColor = Color.bg_bgb.uiColor
            UITabBar.appearance().standardAppearance = standardAppearance
            
            let scrollEdgeAppearance = UITabBarAppearance()
            scrollEdgeAppearance.backgroundColor = Color.bg_bgb.uiColor
            UITabBar.appearance().scrollEdgeAppearance = scrollEdgeAppearance
        }
        .navigationBarBackButtonHidden()
    }
    
    private func drawTabItem(_ item: MainMenuType) -> some View {
        return VStack(alignment: .center, spacing: 8) {
            Image($currentTab.wrappedValue == item.rawValue ? item.onImage : item.offImage)
                .resizable()
                .scaledToFit()
                .frame(both: ICON_SIZE, alignment: .center)
            Text(item.text)
                .sdFont(.caption2, color: Color.cont_gray_mid)
        }
        .background(Color.bg_bgb)
    }
}
