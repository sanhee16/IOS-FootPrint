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
        var goToEditNote: () -> ()
    }
    
    private var output: Output
    private var subscription = Set<AnyCancellable>()
    
    @StateObject var vm: MapVM2 = MapVM2()
    @StateObject var mapManager: FPMapManager = FPMapManager.shared
    @StateObject private var footprintVM: FootprintVM = FootprintVM()
    @StateObject private var searchMapVM: SearchMapVM = SearchMapVM()
    @EnvironmentObject private var coordinator: MapCoordinator
    @EnvironmentObject private var tabBarVM: TabBarVM
    
    private var safeTop: CGFloat { get { Util.safeTop() }}
    private var safeBottom: CGFloat { get { Util.safeBottom() }}
    private let optionHeight: CGFloat = 36.0
    private let optionVerticalPadding: CGFloat = 8.0
    @State private var isShowSearchBar: Bool = false
    @State private var centerPos: CGRect = .zero
    @State private var isPresentFootprint: Bool = false
    @State private var isPresentFootprintSelector: Bool = false
    @State private var selectedId: String? = nil
    @State private var selectedAddress: String? = nil
    @Environment(\.centerLocation) var centerLocation
    
    @State private var selectorWidth: CGFloat = .zero
    
    init(output: Output) {
        self.output = output
    }
    
    var body: some View {
        NavigationStack(path: $coordinator.paths) {
            ZStack(alignment: .topLeading) {
                //MARK: 다중 마커 아이콘 클릭 시
                if let selectedAddress = selectedAddress, $isPresentFootprintSelector.wrappedValue {
                    MultiMarkerSelectorView(address: selectedAddress) { id in
                        $isPresentFootprintSelector.wrappedValue = false
                        self.selectedId = id
                        self.footprintVM.updateId(id)
                        $isPresentFootprint.wrappedValue = true
                    } onClickViewAll: {
                        $isPresentFootprintSelector.wrappedValue = false
                        //TODO: View All
                        
                    } onClickAddNote: { location in
                        $isPresentFootprintSelector.wrappedValue = false
                        if let _ = vm.updateTempLocation(Location(latitude: location.latitude, longitude: location.longitude), address: selectedAddress) {
                            output.goToEditNote()
                        }
                    }
                    .background(
                        GeometryReader { geo in
                            Color.clear
                                .onAppear {
                                    self.selectorWidth = geo.size.width
                                }
                        }
                    )
                    .zIndex(4)
                    .offset(x: (UIScreen.main.bounds.size.width - $selectorWidth.wrappedValue) / 2, y: 174)
                    
                    VStack(alignment: .center) {
                        
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                    .background(Color.black.opacity(0.5))
                    .contentShape(Rectangle())
                    .zIndex(3)
                    .onTapGesture {
                        $isPresentFootprintSelector.wrappedValue = false
                    }
                }
                
                VStack(alignment: .center, spacing: 0, content: {
                    ZStack(content: {
                        // MARK: Map
                        if !$vm.isLoading.wrappedValue {
                            FPMapView(mapView: $mapManager.mapView.wrappedValue)
                                .frame(maxWidth: .infinity, alignment: .center)
                                .zIndex(1)
                        }
                        
                        // MARK: Center position icon
                        if $mapManager.status.wrappedValue == .adding {
                            Image($mapManager.centerMarkerStatus.wrappedValue.image)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 46)
                                .zIndex(3)
                        }
                    })
                })
                
                switch $mapManager.status.wrappedValue {
                case .normal:
                    drawNormalStatus()
                        .zIndex(2)
                    
                case .adding:
                    drawAddingStatus()
                        .zIndex(2)
                }
            }
            .frame(maxWidth: .infinity, alignment: .center).navigationDestination(for: Destination.self) { destination in
                coordinator.moveToDestination(destination: destination)
            }
            .onAppear {
                print("onAppear Map!")
                if $vm.isShowMarkers.wrappedValue {
                    mapManager.loadMarkers()
                }
                vm.onAppear()
            }
            .sheet(isPresented: $isPresentFootprint, onDismiss: {
                $isPresentFootprint.wrappedValue = false
                vm.clearFootprint()
            }, content: {
                FootprintView(isPresented: $isPresentFootprint, output: FootprintView.Output(pushEditNoteView: {
                    if let id = selectedId {
                        //MARK: 편집하기
                        vm.updateTempNote(id)
                        self.output.goToEditNote()
                    }
                }))
                .environmentObject(footprintVM)
                .presentationDetents([.fraction(0.8), .large])
            })
            .onChange(of: $mapManager.selectedMarkers.wrappedValue, perform: { ids in
                if !ids.isEmpty {
                    mapManager.unSelectMarker()
                    if $mapManager.status.wrappedValue == .adding {
                        self.selectedId = nil
                    } else {
                        if let firstId = ids.first {
                            if ids.count == 1 {
                                self.selectedId = firstId
                                self.footprintVM.updateId(firstId)
                                $isPresentFootprint.wrappedValue = true
                            } else {
                                vm.getMultiNoteAddress(firstId) { address in
                                    self.selectedAddress = address
                                    $isPresentFootprintSelector.wrappedValue = true
                                }
                            }
                        }
                    }
                }
            })
        }
    }
    
    private func drawNormalStatus() -> some View {
        VStack(alignment: .leading, spacing: 0, content: {
            if Defaults.shared.premiumCode.isEmpty && $vm.isShowAds.wrappedValue {
                HStack(alignment: .center, spacing: 0, content: {
                    Spacer()
                    GADBanner().frame(width: GADAdSizeBanner.size.width, height: GADAdSizeBanner.size.height)
                        .zIndex(5)
                    Spacer()
                })
            }
            if $vm.isShowSearchBar.wrappedValue {
                HStack(alignment: .center, spacing: 0, content: {
                    Spacer()
                    if isShowSearchBar {
                        VStack(alignment: .leading, spacing: 9, content: {
                            drawSearchBox()
                                .sdPadding(top: 8, leading: 16, bottom: 0, trailing: 16)
                        })
                    }
                    
                    mapMenuButton("search") {
                        withAnimation {
                            self.isShowSearchBar.toggle()
                        }
                    }
                    .sdPadding(top: 8, leading: 0, bottom: 0, trailing: 16)
                })
            }
            ZStack(alignment: .top, content: {
                if isShowSearchBar {
                    if $searchMapVM.searchStatus.wrappedValue != .none {
                        drawSearchList()
                            .sdPaddingTop(8)
                            .zIndex(5)
                    }
                }
                HStack(alignment: .center, spacing: 0, content: {
                    Spacer()
                    markerMenuButton("paw-foot") {
                        if !isShowSearchBar {
                            vm.toggleIsShowMarker()
                            if $vm.isShowMarkers.wrappedValue {
                                mapManager.loadMarkers()
                            } else {
                                mapManager.deleteMarkers()
                            }
                        }
                    }
                    .sdPadding(top: 8, leading: 0, bottom: 0, trailing: 16)
                })
            })
            
            Spacer()
            HStack(alignment: .center, spacing: 0, content: {
                mapMenuButton("location-target") {
                    mapManager.didTapMyLocationButton()
                }
                .sdPadding(top: 0, leading: 16, bottom: 18, trailing: 0)
                .zIndex(3)
                Spacer()
            })
            if !isShowSearchBar {
                FPButton(text: "발자국 남기기", location: .leading(name: "paw-foot-white"), status: .able, size: .large, type: .solid) {
                    //                        output.goToSelectLocation()
                    withAnimation(.smooth) {
                        mapManager.updateMapStatus(.adding)
                    }
                }
                .sdPadding(top: 0, leading: 16, bottom: 8, trailing: 16)
                
                MainMenuBar(current: .map) { type in
                    tabBarVM.onChangeTab(type)
                }
            }
        })
    }
    
    private func drawAddingStatus() -> some View {
        VStack(alignment: .leading, spacing: 0, content: {
            Topbar("위치 선택", type: .close) {
                vm.clearFootprint()
                mapManager.updateMapStatus(.normal)
                if $vm.isShowMarkers.wrappedValue {
                    mapManager.loadMarkers()
                }
            }
            
            Text("지도를 움직여 위치를 설정하세요.")
                .font(.body2)
                .foregroundStyle(Color.white)
                .sdPaddingVertical(16)
                .frame(width: UIScreen.main.bounds.size.width)
                .background(Color.black.opacity(0.7))
            
            Spacer()
            HStack(alignment: .center, spacing: 0, content: {
                mapMenuButton("location-target") {
                    mapManager.didTapMyLocationButton()
                }
                .sdPadding(top: 0, leading: 16, bottom: 18, trailing: 0)
                .zIndex(3)
                Spacer()
            })
            
            VStack(alignment: .leading,
                   spacing: 24,
                   content: {
                Text($mapManager.centerAddress.wrappedValue)
                
                HStack(alignment: .center, spacing: 8, content: {
                    
                    FPButton(text: "여기에 발자국 남기기", status: $mapManager.centerMarkerStatus.wrappedValue == .move ? .disable : .able, size: .large, type: .solid) {
                        if let location = $mapManager.centerPosition.wrappedValue, let _ = vm.updateTempLocation(Location(latitude: location.latitude, longitude: location.longitude), address: $mapManager.centerAddress.wrappedValue) {
                            output.goToEditNote()
                        }
                    }
                })
            })
            .sdPadding(top: 16, leading: 16, bottom: 8, trailing: 16)
            .background(Color(hex: "#F1F5F9"))
        })
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
    
    private func drawSearchList() -> some View {
        return ScrollView(.vertical, showsIndicators: true) {
            VStack(alignment: .leading, spacing: 8) {
                ForEach($searchMapVM.searchItems.wrappedValue.indices, id: \.self) { idx in
                    searchItem($searchMapVM.searchItems.wrappedValue[idx])
                        .skeleton($searchMapVM.searchStatus.wrappedValue == .searching, reason: .placeholder)
                }
            }
        }
        .frame(width: UIScreen.main.bounds.size.width - 16 * 2, height: 65 * 3, alignment: .center)
        .background(Color.dim_white_high)
        .sdPaddingHorizontal(16)
    }
    
    private func searchItem(_ item: SearchEntity) -> some View {
        return VStack(alignment: .leading, spacing: 4) {
            Text(item.name)
                .sdFont(.body1, color: Color.cont_gray_default)
            Text(item.fullAddress)
                .sdFont(.body3, color: Color.cont_gray_mid)
        }
        .sdPadding(top: 8, leading: 16, bottom: 12, trailing: 16)
        .contentShape(Rectangle())
        .frame(maxWidth: .infinity, alignment: .leading)
        .onTapGesture {
            searchMapVM.getLocation(item.placeId) { location in
                if let location = location {
                    mapManager.moveToLocation(location)
                    self.isShowSearchBar.toggle()
                }
            }
            //            vm.onClickSearchItem(item)
//            mapManager.moveToLocation()
        }
    }
    
    private func drawSearchBox() -> some View {
        return HStack(alignment: .center) {
            TextField("", text: $searchMapVM.searchText, prompt: Text("검색어를 입력하세요").sdFont(.body1, color: Color.cont_gray_low).sdPaddingLeading(12) as? Text)
                .sdFont(.body1, color: Color.cont_gray_default)
                .accentColor(.fColor2)
                .sdPaddingHorizontal(8)
                .layoutPriority(.greatestFiniteMagnitude)
                .onChange(of: $searchMapVM.searchText.wrappedValue) { _ in
                    searchMapVM.onTypeText()
                }
            
            if !$searchMapVM.searchText.wrappedValue.isEmpty {
                Button {
                    searchMapVM.onCancel()
                } label: {
                    Image("ic_close")
                        .resizable()
                        .renderingMode(.template)
                        .foregroundColor(Color.cont_gray_mid)
                        .frame(both: 10.0, alignment: .center)
                        .sdPaddingTrailing(12)
                        .sdPaddingTrailing(8)
                        .contentShape(Rectangle())
                }
                .zIndex(10)
            }
        }
        .sdPaddingVertical(10)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .foregroundColor(Color.bg_white)
                .border(Color.btn_ic_stroke_default, lineWidth: 0.75, cornerRadius: 8)
        )
        .contentShape(Rectangle())
        .shadow(color: .black.opacity(0.15), radius: 8, x: 0, y: 2)
    }
}
