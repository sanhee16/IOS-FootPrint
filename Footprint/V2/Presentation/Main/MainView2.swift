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
    @StateObject private var vm: MainVM2 = MainVM2()
    @State private var selectedIndex: Int = 0
    
    var body: some View {
        ZStack(content: {
            VStack(alignment: .leading, spacing: 20) {

            }
            Color.red.opacity(0.7)
            VStack {
                TabView(selection: $selectedIndex) {
                    MapView2()
                        .tabItem {
                            Image(systemName: "house")
                        }
                        .tag(0)
                }
                .accentColor(.black)
            }
        })
        .navigationBarBackButtonHidden()
    }
}
