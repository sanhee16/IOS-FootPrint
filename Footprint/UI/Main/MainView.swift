//
//  MainView.swift
//  Footprint
//
//  Created by Studio-SJ on 2022/10/05.
//


import SwiftUI
import MapKit


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
                // https://www.hackingwithswift.com/quick-start/swiftui/how-to-show-annotations-in-a-map-view
                Map(coordinateRegion: $vm.currenLocation, annotationItems: $vm.annotations.wrappedValue) { item in
                    MapPin(coordinate: item.coordinate)
                }
//                Map(coordinateRegion: $vm.currenLocation)
                Spacer()
                Text("add foot print")
                    .onTapGesture {
                        vm.onClickAddFootprint()
                    }
                Spacer()
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
}
