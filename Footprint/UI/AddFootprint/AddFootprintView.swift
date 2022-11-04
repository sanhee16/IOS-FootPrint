//
//  AddFootprintView.swift
//  Footprint
//
//  Created by Studio-SJ on 2022/11/04.
//

import SwiftUI

struct AddFootprintView: View {
    typealias VM = AddFootprintViewModel
    public static func vc(_ coordinator: AppCoordinator, completion: (()-> Void)? = nil) -> UIViewController {
        let vm = VM.init(coordinator)
        let view = Self.init(vm: vm)
        let vc = BaseViewController.bottomSheet(view, sizes: [.fixed(500)])
        return vc
    }
    @ObservedObject var vm: VM
    
    private var safeTop: CGFloat { get { Util.safeTop() }}
    private var safeBottom: CGFloat { get { Util.safeBottom() }}
    
    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .leading, spacing: 0) {
                Topbar("", type: .back) {
                    vm.onClose()
                }
                VStack(alignment: .leading, spacing: 10) {
                    TextField("enter title", text: $vm.title)
                        .padding(EdgeInsets(top: 6, leading: 8, bottom: 6, trailing: 8))
                        .background(Color(uiColor: .secondarySystemBackground)) //TODO: remove
                    ScrollView(.horizontal, showsIndicators: false) {
                        
                    }
                    MultilineTextField("enter content", text: $vm.content) {
                        
                    }
                    .padding(EdgeInsets(top: 4, leading: 6, bottom: 4, trailing: 6))
                }
                .padding(EdgeInsets(top: 10, leading: 16, bottom: 10, trailing: 16))
                Spacer()
            }
            .padding(EdgeInsets(top: 0, leading: 0, bottom: safeBottom, trailing: 0))
            .edgesIgnoringSafeArea(.all)
            .frame(width: geometry.size.width, alignment: .leading)
        }
        .onAppear {
            vm.onAppear()
        }
    }
}
