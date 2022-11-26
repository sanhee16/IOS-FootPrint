//
//  MainView.swift
//  Footprint
//
//  Created by Studio-SJ on 2022/10/05.
//


import SwiftUI
import MapKit
import NMapsMap


struct MainView: View {
    typealias VM = MainViewModel
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
            VStack(alignment: .center, spacing: 0) {
                ZStack(alignment: .leading) {
                    Topbar("FootPrint", type: .none) {
                    }
                    HStack(alignment: .center, spacing: 0) {
                        Spacer()
                        Text("설정")
                            .font(.kr12r)
                            .foregroundColor(.gray100)
                            .onTapGesture {
                                vm.onClickSetting()
                            }
                    }
                    .padding([.leading, .trailing], 12)
                    .frame(width: geometry.size.width - 24, height: 50, alignment: .center)
                }
                .frame(width: geometry.size.width, height: 50, alignment: .center)
                
                //Naver Map
                if let myLocation = $vm.location.wrappedValue, let coordinator = $vm.coordinator.wrappedValue {
                    ZStack(alignment: .topTrailing) {
                        MapView(coordinator, location: myLocation, vm: vm)
                        drawCategory(geometry)
                    }
                }
            }
            .padding(EdgeInsets(top: safeTop, leading: 0, bottom: safeBottom, trailing: 0))
            .edgesIgnoringSafeArea(.all)
            .frame(width: geometry.size.width, alignment: .center)
        }
        .ignoresSafeArea(.all)
        .onAppear {
            vm.onAppear()
        }
    }
    private func drawCategory(_ geometry: GeometryProxy) -> some View {
        return VStack(alignment: .trailing, spacing: 0) {
            if !$vm.categories.wrappedValue.isEmpty {
                Text("카테고리")
                    .font(.kr12r)
                    .foregroundColor(.white)
                    .padding(EdgeInsets(top: 6, leading: 9, bottom: 6, trailing: 9))
                    .background(
                        RoundedRectangle(cornerRadius: 6)
                            .foregroundColor($vm.isShowCategoriesPannel.wrappedValue ? Color.black.opacity(0.5) : Color.greenTint1.opacity(0.8))
                    )
                    .padding([.top, .trailing], 10)
                    .onTapGesture {
                        $vm.isShowCategoriesPannel.wrappedValue = !$vm.isShowCategoriesPannel.wrappedValue
                    }
                if $vm.isShowCategoriesPannel.wrappedValue {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(alignment: .center, spacing: 0) {
                            ForEach($vm.categories.wrappedValue.indices, id: \.self) { idx in
                                let category = $vm.categories.wrappedValue[idx]
                                categoryItem(category)
                            }
                        }
                    }
                    .contentShape(Rectangle())
                    .background(
                        RoundedRectangle(cornerRadius: 6)
                            .foregroundColor(Color.greenTint1.opacity(0.8))
                    )
                    .frame(width: geometry.size.width - 20, alignment: .trailing)
                    .padding(8)
                }
            }
        }
        .contentShape(Rectangle())
        .frame(width: geometry.size.width, alignment: .trailing)
    }
    private func categoryItem(_ category: Category) -> some View {
        return Text(category.name)
            .font(.kr13r)
            .foregroundColor($vm.showingCategories.wrappedValue.contains(category.name) ? .black : .white.opacity(0.8))
            .padding(10)
            .contentShape(Rectangle())
            .onTapGesture {
                vm.onClickCategory(category)
            }
    }
}
