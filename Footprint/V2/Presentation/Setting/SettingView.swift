//
//  SettingView.swift
//  Footprint
//
//  Created by sandy on 11/24/24.
//

import SwiftUI
import SDSwiftUIPack
import MessageUI

struct SettingView: View {
    struct Output {
        var pushSetMapIconView: () -> ()
        var pushPermissionView: () -> ()
        var pushMemberListEditView: () -> ()
        var pushCategoryListEditView: () -> ()
        var pushPrivacyPolicyView: (String) -> ()
    }
    
    private var output: Output
    
    @EnvironmentObject private var coordinator: SettingCoordinator
    @EnvironmentObject private var tabBarVM: TabBarVM
    @StateObject private var vm: SettingVM = SettingVM()
    @State var isShowMailView = false
    @State var isShowMailAlert = false
    @State var result: Result<MFMailComposeResult, Error>? = nil
    
    init(output: Output) {
        self.output = output
    }
    
    var body: some View {
        NavigationStack(path: $coordinator.paths) {
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
                            self.output.pushSetMapIconView()
                        }
                        SettingArrowItem(text: "권한 확인하기") {
                            self.output.pushPermissionView()
                        }
                        
                        title("콘텐츠")
                            .sdPaddingTop(40)
                        SettingArrowItem(text: "함께한 사람 편집하기") {
                            self.output.pushMemberListEditView()
                        }
                        SettingArrowItem(text: "카테고리 편집하기") {
                            self.output.pushCategoryListEditView()
                        }
                        
                        title("운영")
                            .sdPaddingTop(40)
                        
                        if MFMailComposeViewController.canSendMail() {
                            SettingArrowItem(text: "문의하기") {
                                self.isShowMailView = true
                            }
                        }
                        if let url = $vm.url.wrappedValue {
                            SettingArrowItem(text: "개인정보 처리방침") {
                                self.output.pushPrivacyPolicyView(url)
                            }
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
            .navigationBarBackButtonHidden()
            .navigationDestination(for: Destination.self) { destination in
                coordinator.moveToDestination(destination: destination)
            }
            .sheet(isPresented: $isShowMailView) {
                MailView(isShowing: $isShowMailView, result: $result)
            }
            .onAppear {
                
            }
        }
    }
    
    private func title(_ text: String) -> some View {
        Text(text)
            .sdFont(.headline4, color: Color.zineGray_700)
            .sdPaddingTop(24)
    }
}
