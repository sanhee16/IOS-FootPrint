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
        var goToEditNote: (EditNoteType) -> ()
    }
    private var output: Output
    
    @StateObject var vm: SelectLocationVM = SelectLocationVM()
    @ObservedObject var mapManager: FPMapManager = FPMapManager.shared
    
    private var safeTop: CGFloat { get { Util.safeTop() }}
    private var safeBottom: CGFloat { get { Util.safeBottom() }}
    private let optionHeight: CGFloat = 36.0
    private let optionVerticalPadding: CGFloat = 8.0
//    private let location: Location
    @State private var centerPos: CGRect = .zero
    
    @Environment(\.centerLocation) var centerLocation

    init(output: Output) {
        self.output = output
    }
    
    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .center, spacing: 0) {
                //Google Map
                ZStack(alignment: .topLeading) {
                    VStack(alignment: .leading, spacing: 0, content: {
                        Topbar("위치 선택", type: .back) {
                            self.output.pop()
                        }
                        Text("지도를 움직여 위치를 설정하세요.")
                            .font(.body2)
                            .foregroundStyle(Color.white)
                            .sdPaddingVertical(16)
                            .frame(width: geometry.size.width)
                            .background(Color.black.opacity(0.7))
                    })
                    .zIndex(1)
                    
                    Image($mapManager.centerMarkerStatus.wrappedValue.image)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 46)
                        .zIndex(2)
                        .rectReader($centerPos, in: .global)
                        .offset(x: geometry.size.width / 2 - $centerPos.wrappedValue.width / 2, y: geometry.size.height / 2 - $centerPos.wrappedValue.height / 2)
                    
                    if !$vm.isLoading.wrappedValue {
                        FPMapView(mapView: $mapManager.mapView.wrappedValue)
                            .frame(width: geometry.size.width, height: geometry.size.height, alignment: .center)
                    }
                    
                    VStack(alignment: .leading, spacing: 0, content: {
                        Spacer()
                        
                        VStack(alignment: .leading, spacing: 24, content: {
                            Text($vm.centerAddress.wrappedValue)
                            
                            FPButton(text: "여기에 발자국 남기기", status: .press, size: .large, type: .solid) {
                                if let location = $mapManager.centerPosition.wrappedValue {
                                    output.goToEditNote(
                                        .create(location: Location(latitude: location.latitude, longitude: location.longitude), address: $vm.centerAddress.wrappedValue)
                                    )
                                }
                            }
                        })
                        .sdPadding(top: 16, leading: 16, bottom: 8, trailing: 16)
                        .background(Color(hex: "#F1F5F9"))
                    })
                }
            }
            .frame(width: geometry.size.width, height: geometry.size.height, alignment: .center)
        }
        .onAppear {
            vm.onAppear()
//            vm.setLocation(location: self.location)
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
                        .foregroundStyle(Color.white)
                        .border(Color(hex: "E2E8F0"), lineWidth: 0.7, cornerRadius: 100)
                )
                .shadow(color: .black.opacity(0.15), radius: 8, x: 0, y: 2)
                .contentShape(Rectangle())
        })
    }
}


struct SelectLocationMap: UIViewRepresentable {
    let mapView: GMSMapView
    let changeStateSelectedMarker: (Bool, CLLocationCoordinate2D?) -> ()
    
    init(mapView: GMSMapView, changeStateSelectedMarker: @escaping (Bool, CLLocationCoordinate2D?) -> ()) {
        self.mapView = mapView
        self.changeStateSelectedMarker = changeStateSelectedMarker
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(mapView: mapView, changeStateSelectedMarker: changeStateSelectedMarker)
    }
    
    private let zoom: Float = 17.8
    
    func makeUIView(context: Self.Context) -> GMSMapView {
        self.mapView.delegate = context.coordinator
        return mapView
    }
    
    func updateUIView(_ mapView: GMSMapView, context: Context) {
        
    }
    
    class Coordinator: NSObject, GMSMapViewDelegate {
        let mapView: GMSMapView
        let changeStateSelectedMarker: (Bool, CLLocationCoordinate2D?) -> ()

        init(mapView: GMSMapView, changeStateSelectedMarker: @escaping (Bool, CLLocationCoordinate2D?) -> ()) {
            self.mapView = mapView
            self.changeStateSelectedMarker = changeStateSelectedMarker
        }
        
        func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
            self.changeStateSelectedMarker(true, nil)
        }

        func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
            self.changeStateSelectedMarker(false, position.target)
        }
    }
}
