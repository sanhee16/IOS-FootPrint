//
//  AddTogetherView.swift
//  Footprint
//
//  Created by Studio-SJ on 2022/12/08.
//

import SwiftUI

struct AddTogetherView: View, KeyboardReadable {
    typealias VM = AddTogetherViewModel
    public static func vc(_ coordinator: AppCoordinator, type: AddTogetherType, onEraseTogether: (()->())?, completion: (()-> Void)?) -> UIViewController {
        let vm = VM.init(coordinator, type: type, onEraseTogether: onEraseTogether)
        let view = Self.init(vm: vm)
        let vc = BaseViewController.bottomSheet(view, sizes: [.fixed(400.0)])
        return vc
    }
    @ObservedObject var vm: VM
    
    private var safeTop: CGFloat { get { Util.safeTop() }}
    private var safeBottom: CGFloat { get { Util.safeBottom() }}
    private let IMAGE_SIZE: CGFloat = 55.0
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            ZStack(alignment: .trailing) {
                Topbar("카테고리 추가", type: .close) {
                    vm.onClose()
                }
                
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
            HStack(alignment: .center, spacing: 0) {
                TextField("이름(최대 10자)", text: $vm.name)
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
                //TODO: Image Select할 수 있어야 함
                Spacer()
                Text("+")
                    .font(.kr16b)
                    .foregroundColor(.white)
                    .frame(both: IMAGE_SIZE, aligment: .center)
                    .background(
                        Circle()
                            .foregroundColor(.gray30)
                    )
                    .onTapGesture {
                        vm.onClickGallery()
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
}
