//
//  FootprintListView.swift
//  Footprint
//
//  Created by sandy on 2022/12/10.
//


import SwiftUI

struct FootprintListView: View {
    typealias VM = FootprintListViewModel
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
                ZStack(alignment: .leading) {
                    Topbar("All FootPrints", type: .close) {
                        vm.onClose()
                    }
                    HStack(alignment: .center, spacing: 0) {
                        Spacer()
                        Text("필터")
                            .font(.kr12r)
                            .foregroundColor(.gray100)
                            .onTapGesture {
                                vm.onClickFilter()
                            }
                    }
                    .padding([.leading, .trailing], 12)
                    .frame(width: geometry.size.width - 24, height: 50, alignment: .center)
                }
                .frame(width: geometry.size.width, height: 50, alignment: .center)
                
            }
            .padding(EdgeInsets(top: safeTop, leading: 0, bottom: safeBottom, trailing: 0))
            .edgesIgnoringSafeArea(.all)
            .frame(width: geometry.size.width, alignment: .leading)
        }
        .background(
            Color.lightGray01
        )
        .onAppear {
            vm.onAppear()
        }
    }
    
    private func drawFootprintItem(_ geometry: GeometryProxy, item: FootPrint) -> some View {
        return VStack(alignment: .leading, spacing: 0) {
            Text(item.title)
                .font(.kr14b)
                .foregroundColor(.gray100)
            if let category = item.tag.getCategory() {
                Image(category.pinType.pinType().pinWhite)
                    .resizable()
                    .frame(both: 18.0, aligment: .center)
                    .colorMultiply(Color(hex: category.pinColor.pinColor().pinColorHex))
            }
        }
        .padding(EdgeInsets(top: 16, leading: 12, bottom: 16, trailing: 12))
        .background(Color.white)
    }
}

