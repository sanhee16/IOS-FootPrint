//
//  SplashView.swift
//  Footprint
//
//  Created by Studio-SJ on 2022/10/05.
//


import SwiftUI
import SDSwiftUIPack

struct SplashView: View {
    typealias VM = SplashViewModel
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
                Spacer()
                Image("icon_mark")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 70, height: 110, alignment: .center)
//                LottieView(filename: "loading_bar")
//                    .frame(both: 180.0)
                Spacer()
            }
            .padding(EdgeInsets(top: safeTop, leading: 0, bottom: safeBottom, trailing: 0))
            .edgesIgnoringSafeArea(.all)
            .frame(width: geometry.size.width, alignment: .center)
        }
        .onAppear {
            vm.onAppear()
        }
    }
}
