//
//  PeopleEditView.swift
//  Footprint
//
//  Created by Studio-SJ on 2022/12/16.
//
//

import SwiftUI

struct PeopleEditView: View {
    typealias VM = PeopleEditViewModel
    public static func vc(_ coordinator: AppCoordinator, peopleEditStruct: PeopleEditStruct, completion: (()-> Void)? = nil) -> UIViewController {
        let vm = VM.init(coordinator, peopleEditStruct: peopleEditStruct)
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
    
    private let width: CGFloat = UIScreen.main.bounds.width - 60
    private let imageSize: CGFloat = 40.0
    
    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .center, spacing: 0) {
                Spacer()
                VStack(alignment: .center, spacing: 0) {
                    drawHeader()
                    drawBody(geometry)
                }
                .background(
                    RoundedRectangle(cornerRadius: 18)
                        .foregroundColor(Color.white)
                )
                .frame(width: width, alignment: .center)
                .onAppear {
                    vm.onAppear()
                }
                Spacer()
            }
            .padding([.leading, .trailing], 30)
        }
    }
    
    private func drawBody(_ geometry: GeometryProxy) -> some View {
        return VStack(alignment: .leading, spacing: 10) {
            if let uiImage = $vm.image.wrappedValue {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFit()
                    .frame(both: imageSize, aligment: .center)
                    .clipShape(Circle())
                    .contentShape(Rectangle())
                    .clipped()
                    .onTapGesture {
                        vm.selectImage()
                    }
            } else {
                Image("person")
                    .resizable()
                    .scaledToFit()
                    .frame(both: imageSize, aligment: .center)
                    .clipShape(Circle())
                    .contentShape(Rectangle())
                    .clipped()
                    .background(
                        Circle()
                            .foregroundColor(.gray30)
                    )
                    .onTapGesture {
                        vm.selectImage()
                    }
            }
            
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
                }
                .contentShape(Rectangle())
                .frame(width: width - 24, alignment: .center)
            
            TextField("설명(최대 10자)", text: $vm.intro)
                .padding(EdgeInsets(top: 10, leading: 8, bottom: 10, trailing: 8))
                .background(
                    RoundedRectangle(cornerRadius: 6)
                        .foregroundColor(.greenTint5)
                )
                .onChange(of: $vm.intro.wrappedValue) { newValue in
                    if $vm.intro.wrappedValue == " " {
                        $vm.intro.wrappedValue = ""
                    }
                    if newValue.count > 10 {
                        $vm.intro.wrappedValue.removeLast()
                    }
                }
                .contentShape(Rectangle())
                .frame(width: width - 24, alignment: .center)
        }
        .padding(EdgeInsets(top: 10, leading: 12, bottom: 10, trailing: 12))
    }
    
    private func drawHeader() -> some View {
        return ZStack(alignment: .center) {
            
            
            Topbar(vm.type == .new ? "함께한 사람 추가하기" : "함께한 사람 수정하기", type: .close) {
                vm.onClose()
            }
            HStack(alignment: .center, spacing: 8) {
                Spacer()
                if vm.type == .new {
                    Text("추가")
                        .font(.kr12r)
                        .foregroundColor(.gray90)
                        .onTapGesture {
                            vm.addItem()
                        }
                } else {
                    Text("삭제")
                        .font(.kr12r)
                        .foregroundColor(.gray90)
                        .onTapGesture {
                            vm.deleteItem()
                        }
                    Text("저장")
                        .font(.kr12r)
                        .foregroundColor(.gray90)
                        .onTapGesture {
                            vm.saveItem()
                        }
                }
            }
            .padding(.trailing, 12)
        }
    }
}

