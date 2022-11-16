//
//  AddCategoryView.swift
//  Footprint
//
//  Created by sandy on 2022/11/16.
//

import SwiftUI

struct AddCategoryView: View, KeyboardReadable {
    typealias VM = AddCategoryViewModel
    public static func vc(_ coordinator: AppCoordinator, completion: (()-> Void)? = nil) -> UIViewController {
        let vm = VM.init(coordinator)
        let view = Self.init(vm: vm)
        let vc = BaseViewController.init(view, completion: completion)
        vc.modalPresentationStyle = .overCurrentContext
        vc.view.backgroundColor = UIColor.clear
        vc.controller.view.backgroundColor = UIColor.dim
        return vc
    }
    @ObservedObject var vm: VM
    
    private var safeTop: CGFloat { get { Util.safeTop() }}
    private var safeBottom: CGFloat { get { Util.safeBottom() }}
    
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            ZStack(alignment: .trailing) {
                Topbar("카테고리 추가", type: .close) {
                    vm.onClose()
                }
                if $vm.isAvailableSave.wrappedValue {
                    Text("추가")
                        .font(.kr12r)
                        .foregroundColor(.gray90)
                        .padding(.trailing, 12)
                        .onTapGesture {
                            vm.onClickSave()
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
                drawPinSelectArea()
            }
            .padding(EdgeInsets(top: 4, leading: 20, bottom: 10, trailing: 20))
            .frame(width: UIScreen.main.bounds.width - 80, alignment: .center)
            .padding([.leading, .trailing], 20)
        }
        .ignoresSafeArea(.container, edges: [.top, .bottom])
        .frame(width: UIScreen.main.bounds.width - 100, alignment: .center)
        .background(
            RoundedRectangle(cornerRadius: 18)
                .foregroundColor(Color.white)
        )
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
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(alignment: .center, spacing: 6) {
                    ForEach($vm.pinList.wrappedValue, id: \.self) { item in
                        pinItem(item, isSelected: $vm.pinType.wrappedValue == item)
                    }
                }
                .padding(EdgeInsets(top: 6, leading: 12, bottom: 6, trailing: 12))
            }
        }
    }
    
    private func pinItem(_ item: PinType, isSelected: Bool) -> some View {
        return Image(item.pinName)
            .resizable()
            .scaledToFit()
            .frame(both: 20)
            .padding(6)
            .border(isSelected ? .greenTint4 : .clear, lineWidth: 2, cornerRadius: 10)
            .onTapGesture {
                vm.onSelectPin(item)
            }
    }
}
