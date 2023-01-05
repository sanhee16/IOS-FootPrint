//
//  MainMapOptionView.swift
//  Footprint
//
//  Created by Studio-SJ on 2023/01/05.
//

import SwiftUI

struct MainMapOptionView: View {
    typealias VM = MainMapOptionViewModel
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
            VStack(alignment: .leading, spacing: 0) {
                Topbar("지도 옵션 선택하기", type: .back) {
                    vm.onClose()
                }
                
                
            }
            .padding(EdgeInsets(top: safeTop, leading: 0, bottom: safeBottom, trailing: 0))
            .edgesIgnoringSafeArea(.all)
            .frame(width: geometry.size.width, alignment: .leading)
        }
        .onAppear {
            vm.onAppear()
        }
    }
    
    
    private func drawPermissionItem(_ geometry: GeometryProxy, text: String, isOn: Binding<Bool>) -> some View {
        return HStack(alignment: .center, spacing: 0) {
            Text(text)
                .font(.kr11r)
                .foregroundColor(.gray100)
            Spacer()
            SToggleView(width: 36.0, height: 20.0, color: .greenTint2, isOn: isOn) {
                // onTapGesture
                
            }
        }
        .padding([.leading, .trailing], 18)
    }
}
