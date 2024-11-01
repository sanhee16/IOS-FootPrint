//
//  FootprintView.swift
//  Footprint
//
//  Created by sandy on 8/10/24.
//

import Foundation
import SwiftUI
import SwiftUIPager
import SDSwiftUIPack

struct FootprintView: View {
    @StateObject var vm: FootprintVM
    
    init(id: String) {
        _vm = StateObject(wrappedValue: { FootprintVM(id) }())
    }
    
    private var safeTop: CGFloat { get { Util.safeTop() }}
    private var safeBottom: CGFloat { get { Util.safeBottom() }}
    
    private let IMAGE_SIZE: CGFloat = 70.0
    
    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .leading, spacing: 0) {
                if $vm.isFailToLoad.wrappedValue {
                    Text("정보 불러오기에 실패했습니다")
                } else {
                    Text("hello, world!")
                    Text($vm.footPrints.wrappedValue?.address ?? "")
                }
            }
            .padding(EdgeInsets(top: safeTop, leading: 0, bottom: safeBottom, trailing: 0))
            .edgesIgnoringSafeArea(.all)
            .frame(width: geometry.size.width, alignment: .leading)
        }
        .onAppear {
            vm.onAppear()
        }
        .navigationBarBackButtonHidden()
    }
    
//    private func draw
}
