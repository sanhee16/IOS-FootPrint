//
//  SettingView.swift
//  Footprint
//
//  Created by sandy on 2022/12/05.
//

import SwiftUI

/*
 TODO: 설정에 들어갈 것
 이메일 전송
 개인정보처리방침?
 허용된 권한 조회
 사용방법
 
 
 
 */

struct SettingView: View {
    typealias VM = SettingViewModel
    public static func vc(_ coordinator: AppCoordinator, completion: (()-> Void)? = nil) -> UIViewController {
        let vm = VM.init(coordinator)
        let view = Self.init(vm: vm)
        let vc = BaseViewController.init(view, completion: completion)
        return vc
    }
    @ObservedObject var vm: VM
    
    private var safeTop: CGFloat { get { Util.safeTop() }}
    private var safeBottom: CGFloat { get { Util.safeBottom() }}
    
    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .leading, spacing: 0) {
                Topbar("설정", type: .none)
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 0) {
                        drawTitle(geometry, title: "앱 설정")
                        drawItem(geometry, title: "휴지통") {
                            vm.onClickTrash()
                        }
                        drawItem(geometry, title: "권한 확인하기") {
                            vm.onClickCheckPermission()
                        }
                        drawItem(geometry, title: "함께한 사람 편집하기") {
                            vm.onClickEditPeopleWith()
                        }
                        drawItem(geometry, title: "카테고리 편집하기") {
                            vm.onClickEditCategory()
                        }
                        drawToggleItem(geometry, title: "검색창 표시", flag:.SEARCH_BAR, isOn: $vm.isOnSearchBar)
                        drawTitle(geometry, title: "기타")
                        drawItem(geometry, title: "문의하기") {
                            vm.onClickContact()
                        }
                        drawItem(geometry, title: "개발자 정보") {
                            vm.onClickDevInfo()
                        }
                    }
                }
                .frame(width: geometry.size.width, height: geometry.size.height - 50, alignment: .leading)
            }
            .sheet(isPresented: $vm.isShowingMailView) {
                MailView(isShowing: $vm.isShowingMailView, result: $vm.result)
            }
            .padding(EdgeInsets(top: safeTop, leading: 0, bottom: safeBottom, trailing: 0))
            .edgesIgnoringSafeArea(.all)
            .frame(width: geometry.size.width, alignment: .leading)
        }
        .onAppear {
            vm.onAppear()
        }
    }
    
    private func drawTitle(_ geometry: GeometryProxy, title: String, description: String? = nil) -> some View {
        return VStack(alignment: .center, spacing: 1) {
            Text(title)
                .font(.kr12b)
                .foregroundColor(.textColor1)
            if let description = description {
                Text(description)
                    .font(.kr9r)
                    .foregroundColor(.gray60)
            }
        }
        .padding(EdgeInsets(top: 10, leading: 10, bottom: 0, trailing: 10))
    }
    
    private func drawItem(_ geometry: GeometryProxy, title: String, description: String? = nil, onTap: (()->())? = nil) -> some View {
        return VStack(alignment: .center, spacing: 0) {
            HStack(alignment: .center, spacing: 0) {
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.kr14r)
                        .foregroundColor(.textColor1)
                    if let description = description {
                        Text(description)
                            .font(.kr11r)
                            .foregroundColor(.gray60)
                    }
                }
                Spacer()
                Image("forward")
                    .resizable()
                    .frame(both: 20.0, aligment: .center)
            }
            .padding(EdgeInsets(top: 14, leading: 12, bottom: 14, trailing: 12))
            .contentShape(Rectangle())
            .onTapGesture {
                print("onTap")
                onTap?()
            }
            Divider()
                .padding([.leading, .trailing], 4)
                .opacity(0.7)
        }
        .padding([.top, .bottom], 2)
    }
    
    private func drawToggleItem(_ geometry: GeometryProxy, title: String, description: String? = nil, flag: SettingFlag, isOn: Binding<Bool>) -> some View {
        return VStack(alignment: .center, spacing: 0) {
            HStack(alignment: .center, spacing: 0) {
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.kr14r)
                        .foregroundColor(.textColor1)
                    if let description = description {
                        Text(description)
                            .font(.kr11r)
                            .foregroundColor(.gray60)
                    }
                }
                Spacer()
                SToggleView(isOn: isOn) {
                    print("toggle! \(isOn.wrappedValue)")
                    vm.onToggleSetting(flag, isOn: isOn.wrappedValue)
                }
            }
            .padding(EdgeInsets(top: 14, leading: 12, bottom: 14, trailing: 12))
            .contentShape(Rectangle())
            Divider()
                .padding([.leading, .trailing], 4)
                .opacity(0.7)
        }
        .padding([.top, .bottom], 2)
    }
}
