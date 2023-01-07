//
//  AddCategoryView.swift
//  Footprint
//
//  Created by sandy on 2022/11/16.
//

import SwiftUI

struct AddCategoryView: View, KeyboardReadable {
    typealias VM = AddCategoryViewModel
    public static func vc(_ coordinator: AppCoordinator, type: AddCategoryType, onEraseCategory: (()->())?, completion: (()-> Void)?) -> UIViewController {
        let vm = VM.init(coordinator, type: type, onEraseCategory: onEraseCategory)
        let view = Self.init(vm: vm)
        let vc = BaseViewController.bottomSheet(view, sizes: [.fixed(400.0)])
        return vc
    }
    @ObservedObject var vm: VM
    
    private var safeTop: CGFloat { get { Util.safeTop() }}
    private var safeBottom: CGFloat { get { Util.safeBottom() }}
    private let columnCnt: Int = 9
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            ZStack(alignment: .trailing) {
                Topbar($vm.type.type.wrappedValue == .create ? "카테고리 추가" : "카테고리 편집", type: .close) {
                    vm.onClose()
                }
                //TODO: 삭제 버튼 만들고 로직 추가
                HStack(alignment: .center, spacing: 0) {
                    Spacer()
                    if $vm.type.wrappedValue.type == .update {
                        Text("삭제")
                            .font(.kr12r)
                            .foregroundColor(.gray90)
                            .padding(.trailing, 12)
                            .onTapGesture {
                                vm.onClickDelete()
                            }
                    }
                    if $vm.isAvailableSave.wrappedValue {
                        Text($vm.type.wrappedValue.type == .update ? "저장" : "추가")
                            .font(.kr12r)
                            .foregroundColor(.gray90)
                            .padding(.trailing, 12)
                            .onTapGesture {
                                vm.onClickSave()
                            }
                    }
                }
            }
            VStack(alignment: .center, spacing: 12) {
                TextField("카테고리 이름(최대 10자)", text: $vm.name)
                    .padding(EdgeInsets(top: 10, leading: 8, bottom: 10, trailing: 8))
                    .background(
                        RoundedRectangle(cornerRadius: 6)
                            .foregroundColor(.greenTint5)
                    )
                    .onChange(of: $vm.name.wrappedValue) { newValue in
                        if $vm.name.wrappedValue == " " {
                            $vm.name.wrappedValue = ""
                        }
                        if newValue.count > 10 {
                            $vm.name.wrappedValue.removeLast()
                        }
                        $vm.isAvailableSave.wrappedValue = !$vm.name.wrappedValue.isEmpty
                    }
                    .onReceive(keyboardPublisher) { newIsKeyboardVisible in
                        $vm.isKeyboardVisible.wrappedValue = newIsKeyboardVisible
                    }
                    .contentShape(Rectangle())
                    .frame(width: UIScreen.main.bounds.width - 20, alignment: .center)
                    .padding([.leading, .trailing], 10)
                VStack(alignment: .leading, spacing: 12) {
                    drawPinSelectArea()
                    drawPinColorSelectArea()
                }
            }
            .padding(EdgeInsets(top: 4, leading: 0, bottom: 10, trailing: 0))
            Spacer()
        }
        .ignoresSafeArea(.container, edges: [.top, .bottom])
        .frame(width: UIScreen.main.bounds.width, alignment: .leading)
        .onAppear {
            vm.onAppear()
        }
    }
    
    private func drawPinSelectArea() -> some View {
        return VStack(alignment: .leading, spacing: 4) {
            Text("pin 선택")
                .font(.kr11b)
                .foregroundColor(.gray90)
                .padding(EdgeInsets(top: 10, leading: 18, bottom: 6, trailing: 12))
            
            LazyVGrid(columns: Array(repeating: .init(.flexible(), spacing: 1), count: columnCnt), spacing: 10) {
                ForEach(vm.pinList, id: \.self) { item in
                    pinItem(item, isSelected: $vm.pinType.wrappedValue == item)
                }
            }
            .padding(EdgeInsets(top: 6, leading: 12, bottom: 6, trailing: 12))
        }
    }
    
    private func drawPinColorSelectArea() -> some View {
        return VStack(alignment: .leading, spacing: 4) {
            Text("pin 색상 선택")
                .font(.kr11b)
                .foregroundColor(.gray90)
                .padding(EdgeInsets(top: 10, leading: 18, bottom: 6, trailing: 12))
            
            HStack(alignment: .center, spacing: 0, content: {
                ForEach(vm.pinColorList, id: \.self) { item in
                    Spacer()
                    pinColorItem(item, isSelected: $vm.pinColor.wrappedValue == item)
                }
                Spacer()
            })
            .padding(EdgeInsets(top: 6, leading: 12, bottom: 6, trailing: 12))
        }
    }
    
    private func pinItem(_ item: PinType, isSelected: Bool) -> some View {
        return Image(item.pinWhite)
                .resizable()
                .scaledToFit()
                .frame(both: (UIScreen.main.bounds.width - 24 - CGFloat(columnCnt - 1) * 10) / CGFloat(columnCnt))
                .colorMultiply(Color(hex: $vm.pinColor.wrappedValue.pinColorHex))
                .padding(3)
                .border(isSelected ? .greenTint4 : .clear, lineWidth: 2, cornerRadius: 10)
                .onTapGesture {
                    vm.onSelectPin(item)
                }
    }
    
    private func pinColorItem(_ item: PinColor, isSelected: Bool) -> some View {
        return ZStack(alignment: .center) {
            Circle()
                .frame(both: 18.0, aligment: .center)
                .foregroundColor(Color(hex: item.pinColorHex))
            if isSelected {
                Circle()
                    .frame(both: 13.0, aligment: .center)
                    .foregroundColor(Color(hex: item.pinColorHex))
                    .overlay(
                        Circle()
                            .stroke(Color.white, lineWidth: 2.4)
                    )
            }
        }
        .onTapGesture {
            vm.onSelectPinColor(item)
        }
    }
}
