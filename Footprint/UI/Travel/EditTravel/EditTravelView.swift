//
//  EditTravelView.swift
//  Footprint
//
//  Created by Studio-SJ on 2022/12/27.
//

import SwiftUI
import UniformTypeIdentifiers


struct EditTravelView: View {
    typealias VM = EditTravelViewModel
    public static func vc(_ coordinator: AppCoordinator, type: EditTravelType, completion: (()-> Void)? = nil) -> UIViewController {
        let vm = VM.init(coordinator, type: type)
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
                    HStack(alignment: .center, spacing: 12) {
                        Spacer()
                        if !$vm.title.wrappedValue.isEmpty && !$vm.footprints.wrappedValue.isEmpty {
                            Text("저장")
                                .font(.kr12r)
                                .foregroundColor(.gray90)
                                .onTapGesture {
                                    vm.onClickSave()
                                }
                        }
                    }
                    .padding([.leading, .trailing], 12)
                    .frame(width: geometry.size.width - 24, height: 50, alignment: .center)
                    
                }
                drawInputBox(geometry)
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
        return VStack(alignment: .leading, spacing: 10) {
            drawTitle("여행 제목")
            TextField("enter title", text: $vm.title)
                .padding(EdgeInsets(top: 10, leading: 8, bottom: 10, trailing: 8))
                .background(
                    RoundedRectangle(cornerRadius: 6)
                        .foregroundColor(.inputBoxColor)
                )
                .contentShape(Rectangle())
            
            drawTitle("간단 소개글")
            TextField("enter intro", text: $vm.intro)
                .padding(EdgeInsets(top: 10, leading: 8, bottom: 10, trailing: 8))
                .background(
                    RoundedRectangle(cornerRadius: 6)
                        .foregroundColor(.inputBoxColor)
                )
                .contentShape(Rectangle())
            
            drawTitle("색상 선택")
            ColorPicker("", selection: $vm.color, supportsOpacity: false)
            drawTitle("노트 선택")
            ScrollView(.vertical, showsIndicators: false) {
                ForEach($vm.footprints.wrappedValue.indices, id: \.self) { idx in
                    let item = $vm.footprints.wrappedValue[idx]
                    drawSelectFootprintBox(geometry, item: item)
                }
                drawAddNewItem(geometry)
                    .padding(.bottom, 20)
            }
        }
        .padding([.leading, .trailing], 16)
    }
    
    private func drawTitle(_ title: String) -> some View {
        return Text(title)
            .font(.kr12b)
            .foregroundColor(.textColor1)
            .padding(.top, 4)
    }
    
    private func drawSelectFootprintBox(_ geometry: GeometryProxy, item: FootPrint) -> some View {
        return VStack(alignment: .leading, spacing: 6) {
            HStack(alignment: .center, spacing: 0) {
                Text(item.title)
                    .font(.kr12b)
                    .foregroundColor(.gray90)
                Spacer()
                Image("close")
                    .resizable()
                    .frame(both: 10.0, aligment: .center)
                    .padding(6)
                    .background(
                        Circle()
                            .foregroundColor(.white)
                    )
                    .onTapGesture {
                        vm.onClickDeleteFootprint(item)
                    }
            }
            Spacer()
        }
        .padding(EdgeInsets(top: 10, leading: 8, bottom: 10, trailing: 8))
        .contentShape(Rectangle())
        .frame(
            minWidth:  geometry.size.width - 32, idealWidth:  geometry.size.width - 32, maxWidth: geometry.size.width - 32,
            minHeight: 100, idealHeight: nil, maxHeight: nil, alignment: .leading
        )
        .background(
            RoundedRectangle(cornerRadius: 12)
                .foregroundColor(.fColor4)
        )
        .onDrag {
            $vm.draggedItem.wrappedValue = item
            return NSItemProvider(item: nil, typeIdentifier: item.title)
        }
        .onDrop(of: [UTType.text], delegate: DragAndDropService<FootPrint>(currentItem: item, items: $vm.footprints, draggedItem: $vm.draggedItem)
        )
    }
    
    private func drawAddNewItem(_ geometry: GeometryProxy) -> some View {
        return VStack(alignment: .center, spacing: 6) {
            Text("+")
                .font(.kr30b)
                .foregroundColor(.white)
        }
        .padding(EdgeInsets(top: 4, leading: 6, bottom: 4, trailing: 6))
        .contentShape(Rectangle())
        .frame(width: geometry.size.width - 32, height: 100, alignment: .center)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .foregroundColor(.textColor3)
        )
        .onTapGesture {
            vm.onClickAddFootprints()
        }
    }
}
