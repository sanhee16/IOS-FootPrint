//
//  EditTravelView.swift
//  Footprint
//
//  Created by Studio-SJ on 2022/12/27.
//

import SwiftUI
import SDSwiftUIPack
import UniformTypeIdentifiers
import SDSwiftUIPack

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
                    Topbar($vm.title.wrappedValue, type: .back) {
                        vm.onClickSave()
                    }
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
            drawTitle("title".localized())
            TextField("travel_title".localized(), text: $vm.title)
                .padding(EdgeInsets(top: 10, leading: 8, bottom: 10, trailing: 8))
                .background(
                    RoundedRectangle(cornerRadius: 6)
                        .foregroundColor(.inputBoxColor)
                )
                .onChange(of: $vm.title.wrappedValue) { newValue in
                    if $vm.title.wrappedValue == " " {
                        $vm.title.wrappedValue = ""
                    }
                    if newValue.count > 10 {
                        $vm.title.wrappedValue.removeLast()
                    }
                }
                .contentShape(Rectangle())
            
            drawTitle("introduction".localized())
            TextField("introduction".localized(), text: $vm.intro)
                .padding(EdgeInsets(top: 10, leading: 8, bottom: 10, trailing: 8))
                .background(
                    RoundedRectangle(cornerRadius: 6)
                        .foregroundColor(.inputBoxColor)
                )
                .contentShape(Rectangle())
            
            drawTitle("date".localized())
            drawDateArea(geometry)
            
            drawTitle("color".localized())
            ColorPicker("", selection: $vm.color, supportsOpacity: false)
                .labelsHidden()
            
            drawTitle("footprints".localized())
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
    
    private func drawDateArea(_ geometry: GeometryProxy) -> some View {
        return HStack(alignment: .center, spacing: 0) {
            DatePicker(selection: $vm.fromDate, displayedComponents: [.date]) {
            }
            .labelsHidden()
            Spacer()
            Image("right_arrow")
                .resizable()
                .scaledToFit()
                .frame(width: 40.0, height: 30.0, alignment: .center)
            Spacer()
            DatePicker(selection: $vm.toDate, displayedComponents: [.date]) {
            }
            .labelsHidden()
        }
    }
    
    private func drawSelectFootprintBox(_ geometry: GeometryProxy, item: FootPrint) -> some View {
        return VStack(alignment: .leading, spacing: 6) {
            HStack(alignment: .center, spacing: 0) {
                Text(item.title)
                    .font(.kr12b)
                    .foregroundColor(.gray90)
                Spacer()
                Image("drag_drop")
                    .resizable()
                    .frame(both: 20.0, alignment: .center)
            }
        }
        .padding(EdgeInsets(top: 10, leading: 8, bottom: 10, trailing: 8))
        .contentShape(Rectangle())
        .frame(
            minWidth:  geometry.size.width - 32, idealWidth:  geometry.size.width - 32, maxWidth: geometry.size.width - 32,
            minHeight: 50, idealHeight: nil, maxHeight: nil, alignment: .leading
        )
        .background(
            RoundedRectangle(cornerRadius: 12)
                .foregroundColor(.fColor4)
        )
        .onDrag {
            $vm.draggedItem.wrappedValue = item
            return NSItemProvider(item: nil, typeIdentifier: item.title)
        }
        .onDrop(of: [UTType.text], delegate: DragAndDropService<FootPrint>(currentItem: item, items: $vm.footprints, draggedItem: $vm.draggedItem))
    }
    
    private func drawAddNewItem(_ geometry: GeometryProxy) -> some View {
        return VStack(alignment: .center, spacing: 6) {
            Text("+")
                .font(.kr30b)
                .foregroundColor(.white)
        }
        .padding(EdgeInsets(top: 4, leading: 6, bottom: 4, trailing: 6))
        .frame(width: geometry.size.width - 32, height: 50, alignment: .center)
        .addItemBackground()
        .onTapGesture {
            vm.onClickAddFootprints()
        }
    }
}
