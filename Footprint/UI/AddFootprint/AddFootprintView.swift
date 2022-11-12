//
//  AddFootprintView.swift
//  Footprint
//
//  Created by Studio-SJ on 2022/11/04.
//

import SwiftUI

struct AddFootprintView: View, KeyboardReadable {
    typealias VM = AddFootprintViewModel
    public static func vc(_ coordinator: AppCoordinator, location: Location, completion: (()-> Void)? = nil) -> UIViewController {
        let vm = VM.init(coordinator, location: location)
        let view = Self.init(vm: vm)
        let vc = BaseViewController(view, completion: completion)
//        let vc = BaseViewController.bottomSheet(view, sizes: [.fixed(500)])
        return vc
    }
    @ObservedObject var vm: VM
    
    private var safeTop: CGFloat { get { Util.safeTop() }}
    private var safeBottom: CGFloat { get { Util.safeBottom() }}
    
    private let IMAGE_SIZE: CGFloat = 70.0
    
    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .leading, spacing: 0) {
                drawHeader(geometry)
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 10) {
                        TextField("enter title", text: $vm.title)
                            .padding(EdgeInsets(top: 10, leading: 8, bottom: 10, trailing: 8))
                            .background(
                                RoundedRectangle(cornerRadius: 6)
                                    .foregroundColor(.greenTint4)
                            )
                            .contentShape(Rectangle())
                            .padding([.leading, .trailing], 16)
                        drawPinSelectArea(geometry)
                        drawImageArea(geometry)
                        .padding([.leading, .trailing], 16)
                        MultilineTextField("enter content", text: $vm.content) {
                            
                        }
                        .padding(EdgeInsets(top: 8, leading: 6, bottom: 8, trailing: 6))
                        .contentShape(Rectangle())
                        .background(
                            RoundedRectangle(cornerRadius: 2)
                                .foregroundColor(.greenTint4)
                        )
                        .onReceive(keyboardPublisher) { newIsKeyboardVisible in
                            $vm.isKeyboardVisible.wrappedValue = newIsKeyboardVisible
                        }
                        .onChange(of: $vm.content.wrappedValue) { value in
                            if value == " " {
                                $vm.content.wrappedValue = ""
                            }
                        }
                        .padding([.leading, .trailing], 16)
                    }
                    .padding([.top, .bottom], 14)
                }
                Spacer()
            }
            .padding(EdgeInsets(top: safeTop, leading: 0, bottom: $vm.isKeyboardVisible.wrappedValue ? 0 : safeBottom, trailing: 0))
            .ignoresSafeArea(.container, edges: [.top, .bottom])
            .frame(width: geometry.size.width, alignment: .leading)
        }
        .onAppear {
            vm.onAppear()
        }
    }
    
    private func drawHeader(_ geometry: GeometryProxy) -> some View {
        return ZStack(alignment: .leading) {
            Topbar("", type: .back) {
                vm.onClose()
            }
            HStack(alignment: .center, spacing: 0) {
                Spacer()
                Text("저장")
                    .font(.kr12r)
                    .foregroundColor(.gray100)
                    .onTapGesture {
                        vm.onClickSave()
                    }
            }
            .padding([.leading, .trailing], 12)
            .frame(width: geometry.size.width - 24, height: 50, alignment: .center)
        }
        .frame(width: geometry.size.width, height: 50, alignment: .center)
    }
    
    private func drawImageArea(_ geometry: GeometryProxy) -> some View {
        return ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach($vm.images.wrappedValue.indices, id: \.self) { idx in
                    let image = $vm.images.wrappedValue[idx]
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                        .frame(both: IMAGE_SIZE)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .contentShape(Rectangle())
                        .onTapGesture {
                            vm.removeImage(image)
                        }
                }
                Text("+")
                    .font(.kr16b)
                    .foregroundColor(.white)
                    .frame(both: IMAGE_SIZE, aligment: .center)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .foregroundColor(.gray30)
                    )
                    .onTapGesture {
                        vm.onClickGallery()
                    }
            }
        }
    }
    
    
    private func drawPinSelectArea(_ geometry: GeometryProxy) -> some View {
        return ScrollView(.horizontal, showsIndicators: false) {
            HStack(alignment: .center, spacing: 12) {
                ForEach($vm.pinList.wrappedValue, id: \.self) { item in
                    pinItem(item, isSelected: $vm.pinType.wrappedValue == item)
                }
            }
            .padding(EdgeInsets(top: 6, leading: 12, bottom: 6, trailing: 12))
        }
    }
    
    private func pinItem(_ item: PinType, isSelected: Bool) -> some View {
        return Image(item.pinName)
            .resizable()
            .scaledToFit()
            .frame(both: 30)
            .padding(10)
            .border(isSelected ? .greenTint4 : .clear, lineWidth: 2, cornerRadius: 12)
            .onTapGesture {
                vm.onSelectPin(item)
            }
    }
}
