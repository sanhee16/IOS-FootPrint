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
                ZStack(alignment: .leading) {
                    Topbar("FootPrint", type: .none) {
                    }
                    HStack(alignment: .center, spacing: 12) {
                        Text("전체보기")
                            .font(.kr12r)
                            .foregroundColor(.gray100)
                            .onTapGesture {
                                vm.onClickFootprintList()
                            }
                        Text("travel")
                            .font(.kr12r)
                            .foregroundColor(.gray100)
                            .onTapGesture {
                                vm.onClickTravelList()
                            }
                        Spacer()
                        Image("icon_gps")
                            .resizable()
                            .frame(both: 20.0, aligment: .center)
                            .colorMultiply($vm.locationPermission.wrappedValue ? .green : .red)
                            .padding(.trailing, 8)
                            .onTapGesture {
                                if !$vm.locationPermission.wrappedValue {
                                    vm.onClickLocationPermission()
                                }
                            }
                        Text("설정")
                            .font(.kr12r)
                            .foregroundColor(.gray100)
                            .onTapGesture {
                                vm.onClickSetting()
                            }
                    }
                    .frame(width: geometry.size.width - 24, height: 50, alignment: .center)
                    .padding([.leading, .trailing], 12)
                }
                .frame(width: geometry.size.width, height: 50, alignment: .center)
                //Google Map
                if let coordinator = $vm.coordinator.wrappedValue {
                    ZStack(alignment: .topTrailing) {
                        VStack(alignment: .center, spacing: 0) {
                            drawSearchBox(geometry)
                        }
                        .zIndex(1)
                        GoogleMapView(coordinator, vm: vm)
                    }
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
    
    private func drawSearchBox(_ geometry: GeometryProxy) -> some View {
        return VStack(alignment: .leading, spacing: 10) {
            TextField("", text: $vm.serachText)
                .font(.kr13r)
                .foregroundColor(.gray90)
                .padding([.leading, .trailing], 8)
                .frame(width: geometry.size.width - 40, height: 40, alignment: .center)
                .contentShape(Rectangle())
                .background(
                    RoundedRectangle(cornerRadius: 6)
                        .foregroundColor(Color.white.opacity(0.98))
                )
                .border(.gray60, lineWidth: 1.2, cornerRadius: 6)
                .padding(EdgeInsets(top: 6, leading: 20, bottom: 0, trailing: 20))
                .onChange(of: $vm.serachText.wrappedValue) { _ in
                    vm.enterSearchText()
                }
        }
    }
    
    
    private func drawSearch(_ geometry: GeometryProxy) -> some View {
        return HStack(alignment: .center, spacing: 0) {
            if $vm.isShowingSearchPannel.wrappedValue {
                VStack(alignment: .leading, spacing: 10) {
                    TextField("", text: $vm.serachText)
                        .font(.kr12r)
                        .foregroundColor(.gray90)
                        .padding([.leading, .trailing], 8)
                        .frame(width: geometry.size.width - 60 - 30, height: 34, alignment: .center)
                        .contentShape(Rectangle())
                        .background(
                            RoundedRectangle(cornerRadius: 6)
                                .foregroundColor(Color.white.opacity(0.85))
                        )
                        .padding([.leading, .top, .trailing], 10)
                        .onChange(of: $vm.serachText.wrappedValue) { _ in
                            vm.enterSearchText()
                        }
                }
            }
            Text($vm.isShowingSearchPannel.wrappedValue ? "취소" : "검색")
                .font(.kr12r)
                .foregroundColor(.white)
                .frame(width: 60, height: 34, alignment: .center)
                .background(
                    RoundedRectangle(cornerRadius: 6)
                        .foregroundColor($vm.isShowingSearchPannel.wrappedValue ? Color.black.opacity(0.9) : Color.greenTint1)
                )
                .padding([.top, .trailing], 10)
                .onTapGesture {
                    vm.onTapSearchPannel()
                }
        }
        .contentShape(Rectangle())
        .frame(width: geometry.size.width, alignment: .trailing)
    }
    
    private func drawSearchItem(_ geometry: GeometryProxy, item: FootPrint) -> some View {
        return HStack(alignment: .center, spacing: 12) {
            HStack(alignment: .center, spacing: 6) {
                if let category = item.tag.getCategory() {
                    Image(category.pinType.pinType().pinWhite)
                        .resizable()
                        .frame(both: 18.0, aligment: .center)
                        .colorMultiply(Color(hex: category.pinColor.pinColor().pinColorHex))
                }
                Text(item.title)
                    .font(.kr12r)
                    .foregroundColor(.gray90)
                Spacer()
            }
            .padding(EdgeInsets(top: 6, leading: 8, bottom: 6, trailing: 8))
            .background(
                RoundedRectangle(cornerRadius: 6)
                //                    .foregroundColor(.white.opacity(0.8))
                    .foregroundColor(.greenTint5)
            )
            .contentShape(Rectangle())
            .onTapGesture {
                vm.onClickSearchItem(item)
            }
        }
    }
    
    private func drawCategory(_ geometry: GeometryProxy) -> some View {
        return HStack(alignment: .center, spacing: 0) {
            if !$vm.categories.wrappedValue.isEmpty {
                if $vm.isShowCategoriesPannel.wrappedValue {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(alignment: .center, spacing: 12) {
                            ForEach($vm.categories.wrappedValue.indices, id: \.self) { idx in
                                let category = $vm.categories.wrappedValue[idx]
                                categoryItem(category)
                            }
                        }
                        .padding([.leading, .trailing], 8)
                    }
                    .contentShape(Rectangle())
                    .padding([.leading, .trailing], 8)
                    .frame(width: geometry.size.width - 60 - 30, height: 34, alignment: .center)
                    .background(
                        RoundedRectangle(cornerRadius: 6)
                            .foregroundColor(Color.white.opacity(0.85))
                    )
                    .padding([.leading, .top, .trailing], 10)
                }
                Text("카테고리")
                    .font(.kr12r)
                    .foregroundColor(.white)
                    .frame(width: 60, height: 34, alignment: .center)
                    .background(
                        RoundedRectangle(cornerRadius: 6)
                            .foregroundColor($vm.isShowCategoriesPannel.wrappedValue ? Color.black.opacity(0.9) : Color.greenTint1)
                    )
                    .padding([.top, .trailing], 10)
                    .onTapGesture {
                        $vm.isShowingSearchPannel.wrappedValue = false
                        $vm.isShowCategoriesPannel.wrappedValue = !$vm.isShowCategoriesPannel.wrappedValue
                    }
            }
        }
        .contentShape(Rectangle())
        .frame(width: geometry.size.width, alignment: .trailing)
    }
    
    private func categoryItem(_ category: Category) -> some View {
        return Text(category.name)
            .font(.kr13r)
            .foregroundColor($vm.showingCategories.wrappedValue.contains(category.tag) ? .green : .red)
            .padding([.top, .bottom], 14)
            .contentShape(Rectangle())
            .onTapGesture {
                vm.onClickCategory(category)
            }
    }
}
