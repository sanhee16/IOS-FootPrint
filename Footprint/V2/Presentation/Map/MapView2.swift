//
//  MapView2.swift
//  Footprint
//
//  Created by sandy on 8/10/24.
//

import SwiftUI
import SDSwiftUIPack
import GoogleMobileAds
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
    @State private var isShowSearchBar: Bool = false
    
    init(output: Output) {
        self.output = output
    }
    
    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .center, spacing: 0) {
                //Google Map
                ZStack(alignment: .topLeading) {
                    VStack(alignment: .center, spacing: self.optionVerticalPadding) {
                        if Defaults.premiumCode.isEmpty && $vm.isShowAds.wrappedValue {
                            GADBanner().frame(width: GADAdSizeBanner.size.width, height: GADAdSizeBanner.size.height)
                        }
                        HStack(alignment: .center, spacing: 0, content: {
                            Spacer()
                            
                            if isShowSearchBar {
                                VStack(alignment: .leading, spacing: 9, content: {
                                    drawSearchBox(geometry)
                                        .sdPadding(top: 8, leading: 16, bottom: 0, trailing: 16)
                                        .onTapGesture { }
                                    if !$vm.searchItems.wrappedValue.isEmpty {
                                        drawSearchList(geometry)
                                            .padding(.top, 6)
                                    }
                                })
                            } else {
                                mapMenuButton("search") {
                                    withAnimation {
                                        self.isShowSearchBar = true
                                    }
                                }
                                .sdPadding(top: 8, leading: 0, bottom: 0, trailing: 16)
                            }
                        })
                        
                        HStack(alignment: .center, spacing: 0, content: {
                            Spacer()
                            mapMenuButton("paw-foot") {
                                
                            }
                            .sdPadding(top: 8, leading: 0, bottom: 0, trailing: 16)
                        })
                    }
                    .zIndex(1)
                    
                    GoogleMapView2(vm: self.vm)
                    
                    VStack(alignment: .leading, spacing: 0, content: {
                        Spacer()
                        mapMenuButton("location-target") {
                            vm.didTapMyLocationButton()
                        }
                        .sdPadding(top: 0, leading: 16, bottom: 18, trailing: 0)
                        
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
    
    
    private func mapMenuButton(_ image: String, onTap: @escaping ()->()) -> some View {
        Button(action: {
            onTap()
        }, label: {
            Image(image)
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
        })
    }
    
    private func drawSearchList(_ geometry: GeometryProxy) -> some View {
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
        .frame(width: geometry.size.width - 32, height: geometry.size.height / 5 * 2, alignment: .leading)
        .padding([.leading, .trailing], 16)
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
        return HStack(alignment: .center) {
            Image("search")
                .resizable()
                .scaledToFit()
                .frame(width: 20)
                .contentShape(Rectangle())
                .onTapGesture {
                    self.isShowSearchBar = false
                }
                .sdPaddingLeading(8)
            
            TextField("", text: $vm.searchText)
                .font(.body1)
                .foregroundColor(.gray90)
                .accentColor(.fColor2)
                .sdPaddingHorizontal(8)
                .layoutPriority(.greatestFiniteMagnitude)
                .onChange(of: $vm.searchText.wrappedValue) { _ in
                    vm.enterSearchText()
                }
            
            if !$vm.searchText.wrappedValue.isEmpty {
                Image("close")
                    .resizable()
                    .frame(both: 10.0, alignment: .center)
                    .sdPaddingTrailing(8)
                    .background(
                        Circle()
                            .foregroundColor(.fColor4)
                    )
                    .contentShape(Rectangle())
                    .sdPaddingTrailing(8)
                    .onTapGesture {
                        $vm.searchText.wrappedValue.removeAll()
                        $vm.searchItems.wrappedValue.removeAll()
                    }
            }
        }
        .sdPaddingVertical(10)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .foregroundColor(Color(hex: "#FAFAFA"))
                .border(Color(hex: "#E4E4E7"), lineWidth: 0.75, cornerRadius: 8)
        )
        .contentShape(Rectangle())
        .shadow(color: .black.opacity(0.15), radius: 8, x: 0, y: 2)
    }
}

