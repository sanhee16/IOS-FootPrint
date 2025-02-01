//
//  BluePrintBottomSheetView.swift
//  Footprint
//
//  Created by sandy on 2022/12/18.
//

import SwiftUI

struct BluePrintBottomSheetView: View {
    typealias VM = BluePrintViewModel
    public static func vc(_ coordinator: AppCoordinator, completion: (()-> Void)? = nil) -> UIViewController {
        let vm = VM.init(coordinator)
        let view = Self.init(vm: vm)
        let vc = BaseViewController.init(view, completion: completion) {

        }
        return vc
    }
    @ObservedObject var vm: VM
    
    private var safeTop: CGFloat { get { Util.safeTop() }}
    private var safeBottom: CGFloat { get { Util.safeBottom() }}
    
    private let horizontalPadding: CGFloat = 12.0
    
    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .leading, spacing: 0) {
                Topbar("", type: .back) {
                    vm.onClose()
                }
            }
            .frame(width: geometry.size.width, alignment: .leading)
            .padding([.leading, .trailing], horizontalPadding)
        }
        .onAppear {
            vm.onAppear()
        }
    }
}

