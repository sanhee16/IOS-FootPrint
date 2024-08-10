//
//  PeopleWithSelectorView.swift
//  Footprint
//
//  Created by sandy on 2022/12/11.
//

import SwiftUI
import SDSwiftUIPack


enum PeopleWithEditType {
    case edit
    case select(peopleWith: [PeopleWith], callback: ([PeopleWith])->())
}


struct PeopleWithSelectorView: View {
    typealias VM = PeopleWithSelectorViewModel
    public static func vc(_ coordinator: AppCoordinator, type: PeopleWithEditType, completion: (()-> Void)? = nil) -> UIViewController {
        let vm = VM.init(coordinator, type: type)
        let view = Self.init(vm: vm)
        let vc = BaseViewController.init(view, completion: completion) {

        }
        return vc
    }
    @ObservedObject var vm: VM
    
    private var safeTop: CGFloat { get { Util.safeTop() }}
    private var safeBottom: CGFloat { get { Util.safeBottom() }}
    private let imageSize: CGFloat = 26.0
    private var scrollViewHeight: CGFloat {
        get {
            400 - 50
        }
    }
    
    
    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .leading, spacing: 0) {
                ZStack(alignment: .leading) {
                    Topbar("", type: .close) {
                        vm.onClose()
                    }
                    HStack(alignment: .center, spacing: 0) {
                        Spacer()
                        if case .select(peopleWith: _, callback: _) = vm.type {
                            Text("complete".localized())
                                .font(.kr12r)
                                .foregroundColor(.gray90)
                                .padding(.trailing, 12)
                                .onTapGesture {
                                    vm.onFinishSelect()
                                }
                        }
                    }
                    .padding([.leading, .trailing], 12)
                }
                .frame(width: geometry.size.width, height: 50, alignment: .center)
                VStack(alignment: .center, spacing: 0) {
                    ScrollView(.vertical, showsIndicators: false) {
                        VStack(alignment: .leading, spacing: 4) {
                            ForEach($vm.peopleWithShowList.wrappedValue.indices, id: \.self) { idx in
                                let item = $vm.peopleWithShowList.wrappedValue[idx]
                                peopleWithItem(geometry, item: item)
                            }
                            addPeopleWithItem(geometry)
                        }
                        .padding(EdgeInsets(top: 8, leading: 0, bottom: 20, trailing: 0))
                    }
                }
                .frame(width: geometry.size.width - 24, height: scrollViewHeight, alignment: .leading)
            }
            .padding(EdgeInsets(top: 0, leading: 0, bottom: safeBottom, trailing: 0))
            .ignoresSafeArea(.container, edges: [.top, .bottom])
            .frame(width: geometry.size.width, alignment: .leading)
            .padding([.leading, .trailing], 12)
        }
        .onAppear {
            vm.onAppear()
        }
    }
    
    private func peopleWithItem(_ geometry: GeometryProxy, item: PeopleWith) -> some View {
        return HStack(alignment: .center, spacing: 12) {
            if let image = ImageManager.shared.getSavedImage(named: item.image) {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .frame(both: imageSize, alignment: .center)
                    .clipShape(Circle())
                    .contentShape(Rectangle())
                    .clipped()
            } else {
                Image("person")
                    .resizable()
                    .scaledToFit()
                    .frame(both: imageSize, alignment: .center)
                    .clipShape(Circle())
                    .contentShape(Rectangle())
                    .clipped()
                    .background(
                        Circle()
                            .foregroundColor(.textColor5)
                    )
            }
            Text(item.name)
                .font(.kr12r)
                .foregroundColor(.textColor1)
            Spacer()
            if vm.isSelectedPeople(item), case .select(_, _) = vm.type {
                Image("done_b")
                    .resizable()
                    .frame(both: 20, alignment: .center)
            }
        }
        .padding([.leading, .trailing], 14)
        .frame(width: geometry.size.width - 24, height: 45.0, alignment: .center)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .foregroundColor(.white)
//                .foregroundColor(vm.isSelectedPeople(item) ? .fColor4 : .textColor5)
        )
        .contentShape(Rectangle())
        .onTapGesture {
            vm.onClickPeopleItem(item)
        }
    }
    private func addPeopleWithItem(_ geometry: GeometryProxy) -> some View {
        return HStack(alignment: .center, spacing: 12) {
            Spacer()
            Text("+")
                .font(.kr15r)
                .foregroundColor(.white)
            Spacer()
        }
        .frame(width: geometry.size.width - 24, height: 45.0, alignment: .center)
        .addItemBackground(8)
        .onTapGesture {
            vm.onClickAddPeople()
        }
    }
}
