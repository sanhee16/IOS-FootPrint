//
//  PeopleWithSelectorView.swift
//  Footprint
//
//  Created by sandy on 2022/12/11.
//

import SwiftUI

struct PeopleWithSelectorView: View {
    typealias VM = PeopleWithSelectorViewModel
    public static func vc(_ coordinator: AppCoordinator, peopleWith: [PeopleWith], callback: @escaping ([PeopleWith])->(), completion: (()-> Void)? = nil) -> UIViewController {
        let vm = VM.init(coordinator, peopleWith: peopleWith, callback: callback)
        let view = Self.init(vm: vm)
        let vc = BaseViewController.bottomSheet(view, sizes: [.fixed(400.0)])
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
                        Text("완료")
                            .font(.kr12r)
                            .foregroundColor(.gray90)
                            .padding(.trailing, 12)
                            .onTapGesture {
                                vm.onFinishSelect()
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
            .background(Color.white)
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
                    .frame(both: imageSize, aligment: .center)
                    .clipShape(Circle())
                    .contentShape(Rectangle())
                    .clipped()
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
                            .foregroundColor(.lightGray01)
                    )
            }
            Text(item.name)
                .font(.kr12r)
                .foregroundColor(.gray100)
            Spacer()
            if vm.isSelectedPeople(item) {
                Image("done_b")
                    .resizable()
                    .frame(both: 20, aligment: .center)
            }
        }
        .padding([.leading, .trailing], 14)
        .frame(width: geometry.size.width - 24, height: 45.0, alignment: .center)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .foregroundColor(vm.isSelectedPeople(item) ? .greenTint5 : .lightGray03)
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
                .foregroundColor(.gray100)
            Spacer()
        }
        .frame(width: geometry.size.width - 24, height: 45.0, alignment: .center)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .foregroundColor(.lightGray03)
        )
        .contentShape(Rectangle())
        .onTapGesture {
            vm.onClickAddPeople()
        }
    }
}
