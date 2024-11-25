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
                    
                    title("기본")
                    SettingToggleItem(text: "검색창 표시", isOn: $vm.isShowSearchBar)
                    SettingArrowItem(text: "지도 아이콘 설정하기") {
                        
                    }
                    SettingArrowItem(text: "권한 확인하기") {
                        
                    }
                    
                    title("콘텐츠")
                        .sdPaddingTop(40)
                    SettingArrowItem(text: "함께한 사람 편집하기") {
                        
                    }
                    SettingArrowItem(text: "카테고리 편집하기") {
                        
                    }
                    
                    title("운영")
                        .sdPaddingTop(40)
                    SettingArrowItem(text: "문의하기") {
                        
                    }
                    SettingArrowItem(text: "개인정보 처리방침") {
                        
                    }
                })
                .sdPaddingHorizontal(16)
                .sdPadding(bottom: 40)
            })
            .background(Color.bg_default)
            
            MainMenuBar(current: .setting) { type in
                tabBarVM.onChangeTab(type)
            }
        }
        .frame(maxWidth: .infinity, alignment: .topLeading)
        .background(Color.bg_default)
        .onAppear {
            
        }
    }
    
    private func title(_ text: String) -> some View {
        Text(text)
            .sdFont(.headline4, color: Color.zineGray_700)
            .sdPaddingTop(24)
    }
}
