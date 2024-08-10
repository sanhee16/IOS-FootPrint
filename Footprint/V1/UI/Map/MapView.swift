//
//  MapView.swift
//  Footprint
//
//  Created by Studio-SJ on 2023/01/16.
//

import SwiftUI
import SDSwiftUIPack
import MapKit
import GoogleMaps
import GooglePlaces

struct MapView: View {
    typealias VM = MapViewModel
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
    private let optionHeight: CGFloat = 36.0
    private let optionVerticalPadding: CGFloat = 8.0
    
    
    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .center, spacing: 0) {
                //Google Map
                if !$vm.isGettingLocation.wrappedValue {
                    if let coordinator = $vm.coordinator.wrappedValue {
                        ZStack(alignment: .topTrailing) {
                            VStack(alignment: .center, spacing: self.optionVerticalPadding) {
                                if Util.getSettingStatus(.SEARCH_BAR) {
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
                }
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
        let searchBoxWidth: CGFloat = 60.0
        return HStack(alignment: .center, spacing: 6) {
            ZStack(alignment: .trailing) {
                TextField("", text: $vm.searchText)
                    .font(.kr13r)
                    .foregroundColor(.gray90)
                    .accentColor(.fColor2)
                    .padding([.leading, .trailing], 8)
                    .frame(
                        width: $vm.isShowingSearchResults.wrappedValue
                        ? geometry.size.width - 20 - searchBoxWidth - 10
                        : geometry.size.width - 20,
                        height: self.optionHeight,
                        alignment: .center
                    )
                    .contentShape(Rectangle()
                    )
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
                        .frame(both: 12.0, alignment: .center)
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
                Text("cancel".localized())
                    .font(.kr13r)
                    .foregroundColor(.white)
                    .frame(width: searchBoxWidth, height: self.optionHeight, alignment: .center)
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

