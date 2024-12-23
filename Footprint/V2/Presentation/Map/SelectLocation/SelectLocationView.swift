//
//  SelectLocationView.swift
//  Footprint
//
//  Created by sandy on 8/13/24.
//

import Foundation
import SwiftUI
import SDSwiftUIPack
import GoogleMobileAds
import MapKit
import GoogleMaps
import GooglePlaces

struct SelectLocationView: View {
    struct Output {
        var pop: () -> ()
    }
    private var output: Output
    
    @StateObject var vm: SelectLocationVM = SelectLocationVM()
    @ObservedObject var mapManager: FPMapManager = FPMapManager.shared
    
    @State private var centerPos: CGRect = .zero
    
    init(output: Output, location: Location) {
        self.output = output
        self.mapManager.moveToLocation(location)
    }
    
    var body: some View {
        ZStack(alignment: .center) {
            
            VStack(alignment: .center, spacing: 0, content: {
                ZStack(content: {
                    FPMapView(mapView: $mapManager.mapView.wrappedValue)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .zIndex(1)
                    
                    Image($mapManager.centerMarkerStatus.wrappedValue.image)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 46)
                        .zIndex(3)
                })
            })
            
            
            VStack(alignment: .leading, spacing: 0, content: {
                Topbar("위치 선택", type: .close) {
                    self.output.pop()
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
                            if let location = $mapManager.centerPosition.wrappedValue {
                                vm.updateTempLocation(Location(latitude: location.latitude, longitude: location.longitude), address: $mapManager.centerAddress.wrappedValue)
                                self.output.pop()
                            }
                        }
                    })
                })
                .sdPadding(top: 16, leading: 16, bottom: 8, trailing: 16)
                .background(Color(hex: "#F1F5F9"))
            })
            .zIndex(2)
        }
        .onAppear {
            mapManager.loadMarkers()
        }
        .navigationBarBackButtonHidden()
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
}
