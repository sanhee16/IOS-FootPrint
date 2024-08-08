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
    public static func vc(_ coordinator: AppCoordinator, peopleEditStruct: PeopleEditStruct, callback: @escaping ((Int?) -> ()), completion: (()-> Void)? = nil) -> UIViewController {
        let vm = VM.init(coordinator, peopleEditStruct: peopleEditStruct, callback: callback)
        let view = Self.init(vm: vm)
        let vc = BaseViewController.init(view, completion: completion) {

        }
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
                drawHeader()
                drawBody(geometry)
                Spacer()
            }
            .padding(EdgeInsets(top: 0, leading: 0, bottom: safeBottom, trailing: 0))
            .ignoresSafeArea(.container, edges: [.top, .bottom])
            .frame(width: geometry.size.width, alignment: .leading)
        }
        .onAppear {
            vm.onAppear()
        }
    }
    
    private func drawBody(_ geometry: GeometryProxy) -> some View {
        return VStack(alignment: .leading, spacing: 10) {
            if let uiImage = $vm.image.wrappedValue {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
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
                    .scaledToFill()
                    .frame(both: imageSize, aligment: .center)
                    .clipShape(Circle())
                    .contentShape(Rectangle())
                    .clipped()
                    .background(
                        Circle()
                            .foregroundColor(.textColor5)
                    )
                    .onTapGesture {
                        vm.selectImage()
                    }
            }
            
            TextField("people_name".localized(), text: $vm.name)
                .padding(EdgeInsets(top: 10, leading: 8, bottom: 10, trailing: 8))
                .background(
                    RoundedRectangle(cornerRadius: 6)
                        .foregroundColor(.inputBoxColor)
                )
                .onChange(of: $vm.name.wrappedValue) { newValue in
                    vm.isChange = true
                    if $vm.name.wrappedValue == " " {
                        $vm.name.wrappedValue = ""
                    }
                    if newValue.count > 10 {
                        $vm.name.wrappedValue.removeLast()
                    }
                }
                .contentShape(Rectangle())
            
            TextField("people_description".localized(), text: $vm.intro)
                .padding(EdgeInsets(top: 10, leading: 8, bottom: 10, trailing: 8))
                .background(
                    RoundedRectangle(cornerRadius: 6)
                        .foregroundColor(.inputBoxColor)
                )
                .onChange(of: $vm.intro.wrappedValue) { newValue in
                    vm.isChange = true
                    if $vm.intro.wrappedValue == " " {
                        $vm.intro.wrappedValue = ""
                    }
                    if newValue.count > 10 {
                        $vm.intro.wrappedValue.removeLast()
                    }
                }
                .contentShape(Rectangle())
        }
        .frame(width: UIScreen.main.bounds.width - 24, alignment: .center)
        .padding(.top, 10)
    }
    
    private func drawHeader() -> some View {
        return ZStack(alignment: .center) {
            Topbar(vm.type == .new ? "add_people_with".localized() : "edit_people_with".localized(), type: .close) {
                vm.onClose()
            }
            HStack(alignment: .center, spacing: 8) {
                Spacer()
                if vm.type == .new {
                    Text("add".localized())
                        .font(.kr12r)
                        .foregroundColor(.gray90)
                        .onTapGesture {
                            vm.addItem()
                        }
                } else {
                    Text("delete".localized())
                        .font(.kr12r)
                        .foregroundColor(.gray90)
                        .onTapGesture {
                            vm.deleteItem()
                        }
                    Text("save".localized())
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

