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
    @StateObject private var tabBarVM: TabBarVM = TabBarVM()
    
    
    private let ICON_SIZE: CGFloat = 24.0
    private let ITEM_WIDTH: CGFloat = UIScreen.main.bounds.width / 4
    private let ITEM_HEIGHT: CGFloat = 64.0
    
    init() {
        UITabBar.appearance().barTintColor = .clear
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            switch $tabBarVM.currentTab.wrappedValue {
            case .map:
                MapView2(output: mapCoordinator.mapOutput)
                    .environmentObject(mapCoordinator)
            case .footprints:
                FootprintListViewV2(output: footprintCoordinator.footprintListViewOutput)
                    .environmentObject(footprintCoordinator)
            case .trip:
                TripListView(output: tripCoordinator.tripListViewOutput)
                    .environmentObject(tripCoordinator)
            default:
                VStack{}
            }
        }
        .environmentObject(tabBarVM)
        .navigationBarBackButtonHidden()
    }
}
