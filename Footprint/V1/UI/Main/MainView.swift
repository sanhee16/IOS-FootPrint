//
//  MainView.swift
//  Footprint
//
//  Created by Studio-SJ on 2022/10/05.
//
/*
 TODO: todo list
 - ✅ 날짜기능 추가
     1. 캘린더 추가
     2. 노트나 여행에 기록(노트는 하루 선택, default는 기록 당시 날짜, 여행은 from-to 형식)
 - 즐겨찾기 추가
     1. 탭에 추가하기
     2. ✅ 노트에만 추가
 - 필터기능 추가
     1. 여행 -> 1개씩만 선택
     2. 노트 -> 카테고리 || 함께한 사람 (or 연산)
 - ✅ 자동저장 기능 추가
    1. 완료/저장 안눌러도 자동으로 바로바로 저장되게??
 - 휴지통 기능 추가
    1. 앱 실행(splash)에서 휴지통에있는거 시간봐서 30일 경과한거 지우기
    2. 설정 탭에서 휴지통 기능 추가
    3. db field 에 버린날짜 추가해서 nil이면 안버린거 nil 아니면 버린거 해서 필터링하면 될 것 같음!
 */

import SwiftUI
import SDSwiftUIPack
import Foundation
import GoogleMobileAds

struct MainView: View {
    typealias VM = MainViewModel
    public static func vc(_ coordinator: AppCoordinator, completion: (()-> Void)? = nil) -> UIViewController {
        let vm = VM.init(coordinator)
        let mapVm = MapViewModel.init(coordinator)
        let listVm = FootprintListViewModel.init(coordinator)
        let travelVm = TravelListViewModel.init(coordinator)
        let settingVm = SettingViewModel.init(coordinator)
        
        let view = Self.init(vm: vm, mapVm: mapVm, listVm: listVm, travelVm: travelVm, settingVm: settingVm)
        
        let vc = BaseViewController.init(view, completion: completion) {
            vm.viewDidLoad()
        }
        return vc
    }
    
    @ObservedObject var vm: VM
    @ObservedObject var mapVm: MapViewModel
    @ObservedObject var listVm: FootprintListViewModel
    @ObservedObject var travelVm: TravelListViewModel
    @ObservedObject var settingVm: SettingViewModel
    
    private var safeTop: CGFloat { get { Util.safeTop() }}
    private var safeBottom: CGFloat { get { Util.safeBottom() }}
    private let optionHeight: CGFloat = 36.0
    private let optionVerticalPadding: CGFloat = 8.0
    
    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .center, spacing: 0) {
                
                switch($vm.currentTab.wrappedValue) {
                case .map:
                    MapView(vm: self.mapVm)
                case .footprints:
                    FootprintListView(vm: self.listVm)
                case .travel:
                    TravelListView(vm: self.travelVm)
                case .setting:
                    SettingView(vm: self.settingVm)
                default:
                    SettingView(vm: self.settingVm)
                }
                if Defaults.premiumCode.isEmpty && $vm.isShowAds.wrappedValue {
                    GADBanner().frame(width: GADAdSizeBanner.size.width, height: GADAdSizeBanner.size.height)
                }

                MainMenuBar(geometry: geometry, current: $vm.currentTab.wrappedValue) { type in
                    vm.onClickTab(type)
                }
            }
            .frame(width: geometry.size.width, alignment: .center)
        }
        .onAppear {
            vm.onAppear()
        }
    }
    
}
