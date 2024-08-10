//
//  MapView2.swift
//  Footprint
//
//  Created by sandy on 8/10/24.
//

import SwiftUI
import SDSwiftUIPack
import MapKit
import GoogleMaps
import GooglePlaces

struct MapView2: View {
    struct Output {
        var goToFootprintView: (Location) -> ()
    }
    
    @StateObject var vm: MapVM2 = MapVM2()
    private var output: Output
    private var safeTop: CGFloat { get { Util.safeTop() }}
    private var safeBottom: CGFloat { get { Util.safeBottom() }}
    private let optionHeight: CGFloat = 36.0
    private let optionVerticalPadding: CGFloat = 8.0
    
    
    init(output: Output) {
        self.output = output
    }
    
    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .center, spacing: 0) {
                //Google Map
                ZStack(alignment: .topLeading) {
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
                    
                    GoogleMapView2(vm: self.vm)
                    
                    
                    
                    VStack(alignment: .leading, spacing: 0, content: {
                        Spacer()
                        Image("location-target")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 20)
                            .padding(10)
                            .background(
                                Circle()
                                    .foregroundStyle(Color.white)
                                    .border(Color(hex: "E2E8F0"), lineWidth: 0.7, cornerRadius: 100)
                            )
                            .shadow(color: .black.opacity(0.15), radius: 8, x: 0, y: 2)
                            .contentShape(Rectangle())
                            .sdPadding(top: 0, leading: 16, bottom: 18, trailing: 0)
                            .onTapGesture {
                                vm.didTapMyLocationButton()
                            }
                        
                        FPButton(text: "발자국 남기기", location: .leading(name: "paw-foot-white"), status: .press, size: .large, type: .solid) {

                        }
                        .sdPadding(top: 0, leading: 16, bottom: 8, trailing: 16)
                    })
                }
            }
            .frame(width: geometry.size.width, alignment: .center)
        }
        .onChange(of: $vm.viewEvent.wrappedValue, perform: { value in
            switch value {
            case .goToFootprintView(let location):
                print("[SD] goToFootprintView")
                self.output.goToFootprintView(location)
            default:
                break
            }
            $vm.viewEvent.wrappedValue = .none
        })
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

