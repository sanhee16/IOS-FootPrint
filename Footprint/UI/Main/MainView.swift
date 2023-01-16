//
//  MainView.swift
//  Footprint
//
//  Created by Studio-SJ on 2022/10/05.
//


import SwiftUI
import MapKit
import GoogleMaps
import GooglePlaces


struct MainView: View {
    typealias VM = MainViewModel
    public static func vc(_ coordinator: AppCoordinator, completion: (()-> Void)? = nil) -> UIViewController {
        let vm = VM.init(coordinator)
        let view = Self.init(vm: vm)
        let vc = BaseViewController.init(view, completion: completion) {
            vm.viewDidLoad()
        }
        return vc
    }
    @ObservedObject var vm: VM
    
    private var safeTop: CGFloat { get { Util.safeTop() }}
    private var safeBottom: CGFloat { get { Util.safeBottom() }}
    
    
    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .center, spacing: 0) {
//                ZStack(alignment: .leading) {
//                    Topbar("FootPrint", type: .none) {
//                    }
//                    HStack(alignment: .center, spacing: 12) {
//                        Text("전체보기")
//                            .font(.kr12r)
//                            .foregroundColor(.textColor1)
//                            .onTapGesture {
//                                vm.onClickFootprintList()
//                            }
//                        Text("travel")
//                            .font(.kr12r)
//                            .foregroundColor(.textColor1)
//                            .onTapGesture {
//                                vm.onClickTravelList()
//                            }
//                        Spacer()
//                        Image("icon_gps")
//                            .resizable()
//                            .frame(both: 20.0, aligment: .center)
//                            .colorMultiply($vm.locationPermission.wrappedValue ? .green : .red)
//                            .padding(.trailing, 8)
//                            .onTapGesture {
//                                if !$vm.locationPermission.wrappedValue {
//                                    vm.onClickLocationPermission()
//                                }
//                            }
//                        Text("설정")
//                            .font(.kr12r)
//                            .foregroundColor(.textColor1)
//                            .onTapGesture {
//                                vm.onClickSetting()
//                            }
//                    }
//                    .frame(width: geometry.size.width - 24, height: 50, alignment: .center)
//                    .padding([.leading, .trailing], 12)
//                }
//                .frame(width: geometry.size.width, height: 50, alignment: .center)
                //Google Map
                if let coordinator = $vm.coordinator.wrappedValue {
                    ZStack(alignment: .topTrailing) {
                        VStack(alignment: .center, spacing: 0) {
                            if Util.getSettingStatus(.IS_ON_SEARCH_BAR) {
                                drawSearchBox(geometry)
                                if $vm.isShowingSearchResults.wrappedValue == true {
                                    drawSearchItems(geometry)
                                        .padding(.top, 6)
                                }
                            }
                        }
                        .zIndex(1)
                        GoogleMapView(coordinator, vm: vm)
                    }
                }
                MainMenuBar(geometry: geometry, current: .map) { type in
                    vm.onClickMenu(type)
                }
                
                //Naver Map
//                if let myLocation = $vm.location.wrappedValue, let coordinator = $vm.coordinator.wrappedValue {
//                    ZStack(alignment: .topTrailing) {
//                        MapView(coordinator, location: myLocation, vm: vm)
//                        VStack(alignment: .center, spacing: 0) {
//                            drawSearch(geometry)
//                            if !$vm.isShowingSearchPannel.wrappedValue {
//                                drawCategory(geometry)
//                            }
//                        }
//                        .zIndex(2)
//                        if $vm.isShowingSearchPannel.wrappedValue {
//                            ScrollView(.vertical, showsIndicators: false) {
//                                VStack(alignment: .leading, spacing: 8) {
//                                    ForEach($vm.searchItems.wrappedValue.indices, id: \.self) { idx in
//                                        let item = $vm.searchItems.wrappedValue[idx]
//                                        drawSearchItem(geometry, item: item)
//                                    }
//                                }
//                            }
//                            .padding(EdgeInsets(top: 12, leading: 10, bottom: 12, trailing: 10))
//                            .background(
//                                RoundedRectangle(cornerRadius: 6)
//                                    .foregroundColor(Color.white.opacity(0.9))
//                            )
//                            .zIndex(1)
//                            .frame(width: geometry.size.width - 20, height: geometry.size.height / 3, alignment: .center)
//                            .padding(EdgeInsets(top: 60, leading: 10, bottom: 0, trailing: 10))
//                            .ignoresSafeArea(.container, edges: [.bottom])
//                        }
//                    }
//                }
            }
            .frame(width: geometry.size.width, alignment: .center)
        }
        .onAppear {
            vm.onAppear()
        }
    }
    
    private func drawSearchItems(_ geometry: GeometryProxy) -> some View {
        return VStack(alignment: .leading, spacing: 0) {
            ZStack(alignment: .center) {
                if $vm.searchTimer.wrappedValue != nil {
                    VStack(alignment: .center, spacing: 8) {
                        Spacer()
                        HStack(alignment: .center, spacing: 0) {
                            Spacer()
                            SandyProgressView(size: 130.0)
                            Spacer()
                        }
                        .frame(width: geometry.size.width - 20, height: geometry.size.height / 5 * 2, alignment: .center)
                        Spacer()
                    }
                    .frame(width: geometry.size.width - 20, height: geometry.size.height / 5 * 2, alignment: .center)
                    .zIndex(1)
                }
                ScrollView(.vertical, showsIndicators: true) {
                    VStack(alignment: .leading, spacing: 8) {
                        ForEach($vm.searchItems.wrappedValue.indices, id: \.self) { idx in
                            searchItem(geometry, item: $vm.searchItems.wrappedValue[idx])
                        }
                    }
                    .padding(EdgeInsets(top: 12, leading: 8, bottom: 12, trailing: 6))
                }
                .frame(width: geometry.size.width - 20, height: geometry.size.height / 5 * 2, alignment: .leading)
            }
            .frame(width: geometry.size.width - 20, height: geometry.size.height / 5 * 2, alignment: .leading)
        }
        .background(
            RoundedRectangle(cornerRadius: 6)
                .foregroundColor(Color.white.opacity(0.90))
        )
        .frame(width: geometry.size.width - 20, height: geometry.size.height / 5 * 2, alignment: .leading)
        .padding([.leading, .trailing], 10)
    }
    
    private func searchItem(_ geometry: GeometryProxy, item: SearchItemResponse) -> some View {
        return VStack(alignment: .leading, spacing: 6) {
            Text(item.name)
                .font(.kr12r)
                .foregroundColor(.textColor1)
            Text(item.fullAddress)
                .font(.kr11r)
                .foregroundColor(.gray60)
            Divider()
                .frame(width: geometry.size.width - 34, alignment: .center)
        }
        .padding([.top, .bottom], 2)
        .frame(width: geometry.size.width - 20, alignment: .leading)
        .contentShape(Rectangle())
        .onTapGesture {
            vm.onClickSearchItem(item)
        }
    }
    
    private func drawSearchBox(_ geometry: GeometryProxy) -> some View {
        return HStack(alignment: .center, spacing: 6) {
            ZStack(alignment: .trailing) {
                TextField("", text: $vm.searchText)
                    .font(.kr13r)
                    .foregroundColor(.gray90)
                    .accentColor(.fColor2)
                    .padding([.leading, .trailing], 8)
                    .frame(width: $vm.isShowingSearchResults.wrappedValue ? geometry.size.width - 20 - 60 : geometry.size.width - 20, height: 36, alignment: .center)
                    .contentShape(Rectangle())
                    .background(
                        RoundedRectangle(cornerRadius: 6)
                            .foregroundColor(Color.white.opacity(0.98))
                    )
                    .border(.fColor2, lineWidth: 1.2, cornerRadius: 6)
                    .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: $vm.isShowingSearchResults.wrappedValue ? 0 : 10))
                    .onChange(of: $vm.searchText.wrappedValue) { _ in
                        vm.enterSearchText()
                    }
                    .onTapGesture {
                        vm.onTapSearchBox()
                    }
                if !$vm.searchText.wrappedValue.isEmpty {
                    Image("close")
                        .resizable()
                        .frame(both: 10.0, aligment: .center)
                        .padding(6)
                        .background(
                            Circle()
                                .foregroundColor(.fColor4)
                        )
                        .contentShape(Rectangle())
                        .padding(.trailing, $vm.isShowingSearchResults.wrappedValue ? 8 : 18)
                        .zIndex(1)
                        .onTapGesture {
                            vm.onClickSearchCancel()
                        }
                }
            }
            if $vm.isShowingSearchResults.wrappedValue {
                Text("닫기")
                    .font(.kr13r)
                    .foregroundColor(.white)
                    .frame(width: 60, height: 36, alignment: .center)
                    .background(
                        RoundedRectangle(cornerRadius: 6)
                            .foregroundColor(Color.fColor2)
                    )
                    .padding(.trailing, 10)
                    .onTapGesture {
                        vm.onCloseSearchBox()
                        UIApplication.shared.hideKeyborad()
                    }
            }
        }
        .padding(.top, 8)
    }
}
