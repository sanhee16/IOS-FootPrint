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
import Combine

struct MapView2: View {
    struct Output {
        var goToEditNote: (TemporaryNote) -> ()
    }
    
    private var output: Output
    private var subscription = Set<AnyCancellable>()
    
    @StateObject var vm: MapVM2 = MapVM2()
    @StateObject var mapManager: FPMapManager = FPMapManager.shared
    @StateObject private var footprintVM: FootprintVM = FootprintVM()
    @EnvironmentObject private var tabBarService: TabBarService
    @EnvironmentObject private var mapStatusVM: MapStatusVM
    
    private var safeTop: CGFloat { get { Util.safeTop() }}
    private var safeBottom: CGFloat { get { Util.safeBottom() }}
    private let optionHeight: CGFloat = 36.0
    private let optionVerticalPadding: CGFloat = 8.0
    @State private var isShowSearchBar: Bool = false
    @State private var centerPos: CGRect = .zero
    @State private var isPresentFootprint: Bool = false
    @State private var selectedId: String? = nil
    @Environment(\.centerLocation) var centerLocation

    
    init(output: Output) {
        self.output = output
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .topLeading) {
                if $mapStatusVM.status.wrappedValue == .adding {
                    Image($mapManager.centerMarkerStatus.wrappedValue.image)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 46)
                        .zIndex(2)
                        .rectReader($centerPos, in: .global)
                        .offset(
                            x: geometry.size.width / 2 - $centerPos.wrappedValue.width / 2,
                            y: geometry.size.height / 2 - $centerPos.wrappedValue.height
                        )
                }
                
                if !$vm.isLoading.wrappedValue {
                    FPMapView(mapView: $mapManager.mapView.wrappedValue)
                        .frame(width: geometry.size.width, height: geometry.size.height, alignment: .center)
                        .zIndex(1)
                }
                
                VStack(alignment: .center,
                       spacing: 0,
                       content: {
                    switch $mapStatusVM.status.wrappedValue {
                    case .normal:
                        if Defaults.shared.premiumCode.isEmpty && $vm.isShowAds.wrappedValue {
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
                            markerMenuButton("paw-foot") {
                                vm.toggleIsShowMarker()
                                if $vm.isShowMarkers.wrappedValue {
                                    mapManager.loadMarkers()
                                } else {
                                    mapManager.deleteMarkers()
                                }
                            }
                            .sdPadding(top: 8, leading: 0, bottom: 0, trailing: 16)
                        })
                    case .adding:
                        VStack(alignment: .leading, spacing: 0, content: {
                            Topbar("위치 선택", type: .close) {
                                vm.clearFootprint()
                                mapStatusVM.updateMapStatus(.normal)
                                if $vm.isShowMarkers.wrappedValue {
                                    mapManager.loadMarkers()
                                }
                            }
                            Text("지도를 움직여 위치를 설정하세요.")
                                .font(.body2)
                                .foregroundStyle(Color.white)
                                .sdPaddingVertical(16)
                                .frame(width: geometry.size.width)
                                .background(Color.black.opacity(0.7))
                        })
                        .zIndex(1)
                    }
                    
                    Spacer()
                    HStack(alignment: .center, spacing: 0, content: {
                        mapMenuButton("location-target") {
                            mapManager.didTapMyLocationButton()
                        }
                        .sdPadding(top: 0, leading: 16, bottom: 18, trailing: 0)
                        Spacer()
                    })
                    
                    switch $mapStatusVM.status.wrappedValue {
                    case .normal:
                        FPButton(text: "발자국 남기기", location: .leading(name: "paw-foot-white"), status: .able, size: .large, type: .solid) {
                            //                        output.goToSelectLocation()
                            withAnimation(.smooth) {
                                mapStatusVM.updateMapStatus(.adding)
                            }
                        }
                        .sdPadding(top: 0, leading: 16, bottom: 8, trailing: 16)
                    case .adding:
                        VStack(alignment: .leading,
                               spacing: 24,
                               content: {
                            Text($mapManager.centerAddress.wrappedValue)
                            
                            HStack(alignment: .center, spacing: 8, content: {
//                                FPButton(text: "닫기", status: .able, size: .large, type: .lightSolid) {
//                                    mapStatusVM.updateMapStatus(.normal)
//                                    vm.clearFootprint()
//                                }
//                                .frame(width: (UIScreen.main.bounds.size.width - 32 - 8) / 10 * 3)
                                
                                FPButton(text: "여기에 발자국 남기기", status: $mapManager.centerMarkerStatus.wrappedValue == .move ? .disable : .able, size: .large, type: .solid) {
                                    if let location = $mapManager.centerPosition.wrappedValue, let note = vm.updateTempLocation(Location(latitude: location.latitude, longitude: location.longitude), address: $mapManager.centerAddress.wrappedValue) {
                                        output.goToEditNote(note)
                                    }
                                }
//                                .frame(width: (UIScreen.main.bounds.size.width - 32 - 8) / 10 * 7)
                            })
                        })
                        .sdPadding(top: 16, leading: 16, bottom: 8, trailing: 16)
                        .background(Color(hex: "#F1F5F9"))
                    }
                    
                })
                .zIndex(2)
            }
            .frame(width: geometry.size.width, height: geometry.size.height, alignment: .center)
        }
        .sheet(isPresented: $isPresentFootprint, onDismiss: {
            $isPresentFootprint.wrappedValue = false
            vm.clearFootprint()
        }, content: {
            FootprintView(isPresented: $isPresentFootprint, output: FootprintView.Output(pushEditNoteView: {
                if let id = selectedId, let note = vm.loadTempFootprint(id) {
                    //MARK: 편집하기
                    self.output.goToEditNote(note)
                }
            }))
            .environmentObject(footprintVM)
            .presentationDetents([.fraction(0.8), .large])
        })
        .onChange(of: $mapManager.selectedMarkers.wrappedValue, perform: { ids in
            if !ids.isEmpty {
                mapManager.unSelectMarker()
                if $mapStatusVM.status.wrappedValue == .adding {
                    self.selectedId = nil
                } else {
                    if ids.count == 1, let firstId = ids.first {
                        self.selectedId = firstId
                        self.footprintVM.updateId(firstId)
                        $isPresentFootprint.wrappedValue = true
                    }
                }
            }
        })
        .onAppear {
            if $vm.isShowMarkers.wrappedValue {
                mapManager.loadMarkers()
            }
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
                        .foregroundStyle(Color.btn_ic_bg_default)
                        .border(Color.btn_ic_stroke_able, lineWidth: 0.7, cornerRadius: 100)
                )
                .shadow(color: .black.opacity(0.15), radius: 8, x: 0, y: 2)
                .contentShape(Rectangle())
        })
    }
    
    private func markerMenuButton(_ image: String, onTap: @escaping ()->()) -> some View {
        Button(action: {
            onTap()
        }, label: {
            Image(image)
                .resizable()
                .renderingMode(.template)
                .scaledToFit()
                .foregroundStyle($vm.isShowMarkers.wrappedValue ? Color.btn_ic_cont_press : Color.btn_ic_cont_default)
                .frame(width: 20)
                .padding(10)
                .background(
                    Circle()
                        .foregroundStyle(Color.btn_ic_bg_default)
                        .border(
                            $vm.isShowMarkers.wrappedValue ? Color.btn_ic_stroke_press : Color.btn_ic_stroke_able, lineWidth: 0.7, cornerRadius: 100)
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
//            vm.onClickSearchItem(item)
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
//                    vm.enterSearchText()
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
