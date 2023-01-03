//
//  CreateTravelView.swift
//  Footprint
//
//  Created by Studio-SJ on 2022/12/27.
//

import SwiftUI

struct CreateTravelView: View {
    typealias VM = CreateTravelViewModel
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
                ZStack(alignment: .center) {
                    Topbar("Travel", type: .back) {
                        vm.onClose()
                    }
                    HStack(alignment: .center, spacing: 0) {
                        Spacer()
                        Text("저장")
                            .font(.kr12r)
                            .foregroundColor(.gray90)
                            .onTapGesture {
                                
                            }
                    }
                    .padding([.leading, .trailing], 12)
                    .frame(width: geometry.size.width - 24, height: 50, alignment: .center)
                    
                }
                ScrollView(.vertical, showsIndicators: false) {
                    drawInputBox(geometry)
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
    
    private func drawInputBox(_ geometry: GeometryProxy) -> some View {
        return VStack(alignment: .leading, spacing: 14) {
            TextField("enter title", text: $vm.title)
                .padding(EdgeInsets(top: 10, leading: 8, bottom: 10, trailing: 8))
                .background(
                    RoundedRectangle(cornerRadius: 6)
                        .foregroundColor(.lightGray01)
                )
                .contentShape(Rectangle())
            
            TextField("enter intro", text: $vm.intro)
                .padding(EdgeInsets(top: 10, leading: 8, bottom: 10, trailing: 8))
                .background(
                    RoundedRectangle(cornerRadius: 6)
                        .foregroundColor(.lightGray02)
                )
                .contentShape(Rectangle())
            
            ColorPicker("색상 선택", selection: $vm.color)
                .padding()
            ForEach($vm.footprints.wrappedValue.indices, id: \.self) { idx in
                let item = $vm.footprints.wrappedValue[idx]
                drawSelectFootprintBox(geometry, item: item)
            }
            drawAddNewItem(geometry)
        }
        .padding([.leading, .trailing], 16)
    }
    
    private func drawSelectFootprintBox(_ geometry: GeometryProxy, item: FootPrint) -> some View {
        return VStack(alignment: .leading, spacing: 6) {
            Text(item.title)
                .font(.kr12b)
                .foregroundColor(.gray90)
            
        }
        .padding(EdgeInsets(top: 4, leading: 6, bottom: 4, trailing: 6))
        .contentShape(Rectangle())
        .frame(
            minWidth:  geometry.size.width - 24, idealWidth:  geometry.size.width - 24, maxWidth: geometry.size.width - 24,
            minHeight: 100, idealHeight: nil, maxHeight: nil, alignment: .leading
        )
        .background(
            RoundedRectangle(cornerRadius: 12)
                .foregroundColor(.lightGray01)
        )
        .onTapGesture {
            
        }
    }
    
    private func drawAddNewItem(_ geometry: GeometryProxy) -> some View {
        return VStack(alignment: .center, spacing: 6) {
            Text("+")
                .font(.kr30b)
                .foregroundColor(.white)
        }
        .padding(EdgeInsets(top: 4, leading: 6, bottom: 4, trailing: 6))
        .contentShape(Rectangle())
        .frame(width: geometry.size.width - 24, height: 100, alignment: .center)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .foregroundColor(.gray60)
        )
        .onTapGesture {
            vm.onClickAddFootprints()
        }
    }
}
