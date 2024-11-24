//
//  SettingView.swift
//  Footprint
//
//  Created by sandy on 11/24/24.
//

import SwiftUI

struct SettingView: View {
    struct Output {
        
    }
    
    private var output: Output
    
    @EnvironmentObject private var coordinator: SettingCoordinator
    @EnvironmentObject private var tabBarVM: TabBarVM
    @StateObject private var vm: SettingVM = SettingVM()
    
    init(output: Output) {
        self.output = output
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Topbar("설정")
            ScrollView(.vertical, showsIndicators: false, content: {
                VStack(alignment: .leading, spacing: 0, content: {
                    #if DEBUG
                    FPButton(text: "디버깅 모드!", status: .press, size: .large, type: .solid) {
                        vm.addData()
                    }
                    #endif
                    
                })
                .sdPaddingHorizontal(16)
                .sdPadding(bottom: 40)
            })
            .background(Color.bg_default)
            
            MainMenuBar(current: .footprints) { type in
                tabBarVM.onChangeTab(type)
            }
        }
        .frame(maxWidth: .infinity, alignment: .topLeading)
        .background(Color.bg_default)
        .onAppear {
            
        }
    }
}
