//
//  PeopleWithSelectorView.swift
//  Footprint
//
//  Created by sandy on 2022/12/11.
//

import SwiftUI

struct PeopleWithSelectorView: View {
    typealias VM = PeopleWithSelectorViewModel
    public static func vc(_ coordinator: AppCoordinator, callback: @escaping  ([PeopleWith])->(), completion: (()-> Void)? = nil) -> UIViewController {
        let vm = VM.init(coordinator, callback: callback)
        let view = Self.init(vm: vm)
//        let vc = BaseViewController.init(view, completion: completion)
        let vc = BaseViewController.bottomSheet(view, sizes: [.fixed(500.0)])
//        vc.modalPresentationStyle = .overCurrentContext
//        vc.view.backgroundColor = UIColor.clear
//        vc.controller.view.backgroundColor = UIColor.dim
        return vc
    }
    @ObservedObject var vm: VM
    
    private var safeTop: CGFloat { get { Util.safeTop() }}
    private var safeBottom: CGFloat { get { Util.safeBottom() }}
    private let imageSize: CGFloat = 40.0
    private var scrollViewHeight: CGFloat {
        get {
            500 - safeTop - safeBottom - 50 - 34 - 30
        }
    }
    
    
    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .leading, spacing: 0) {
                Topbar("", type: .close) {
                    vm.onClose()
                }
                TextField("", text: $vm.serachText)
                    .font(.kr12r)
                    .foregroundColor(.gray90)
                    .padding([.leading, .trailing], 8)
                    .frame(width: geometry.size.width - 24, height: 34, alignment: .center)
                    .contentShape(Rectangle())
                    .background(
                        RoundedRectangle(cornerRadius: 6)
                            .foregroundColor(.lightGray03)
                    )
                    .onChange(of: $vm.serachText.wrappedValue) { _ in
                        vm.enterSearchText()
                    }
                
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 4) {
                        ForEach($vm.peopleWithSelectList.wrappedValue.indices, id: \.self) { idx in
                            let item = $vm.peopleWithSelectList.wrappedValue[idx]
                            peopleWithItem(geometry, item: item)
                        }
                    }
                    .frame(width: geometry.size.width - 24, height: (scrollViewHeight) / 2 - 4 - 20, alignment: .leading)
                    .background(Color.greenTint1)
                    Divider()
                        .padding([.top, .bottom], 2)
                    VStack(alignment: .leading, spacing: 4) {
                        ForEach($vm.peopleWithShowList.wrappedValue.indices, id: \.self) { idx in
                            let item = $vm.peopleWithShowList.wrappedValue[idx]
                            if !vm.isSelectedPeople(item) {
                                peopleWithItem(geometry, item: item)
                            }
                        }
                    }
                    .frame(width: geometry.size.width - 24, height: (scrollViewHeight) / 2 + 20, alignment: .leading)
                    .background(Color.greenTint2)
                }
                .frame(width: geometry.size.width - 24, height: scrollViewHeight, alignment: .leading)
                .padding([.top, .bottom], 10)
                
                Text("선택하기")
                    .font(.kr16b)
                    .foregroundColor(.white)
                    .frame(width: geometry.size.width - 24, height: 50, alignment: .center)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .foregroundColor($vm.peopleWithSelectList.wrappedValue.isEmpty ? .gray30 : .greenTint1)
                    )
                    .onTapGesture {
                        vm.onFinishSelect()
                    }
                    .padding(.bottom, 10)
            }
            .padding(EdgeInsets(top: 0, leading: 0, bottom: safeBottom, trailing: 0))
            .edgesIgnoringSafeArea(.all)
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
                    .scaledToFit()
                    .frame(both: imageSize, aligment: .center)
            } else {
                Circle()
                    .foregroundColor(.gray50)
                    .frame(both: imageSize, aligment: .center)
            }
            Text(item.name)
                .font(.kr12r)
                .foregroundColor(.gray100)
            Spacer()
            if vm.isSelectedPeople(item) {
                Image("done_b")
                    .resizable()
                    .frame(both: 16, aligment: .center)
            }
        }
        .padding(EdgeInsets(top: 6, leading: 8, bottom: 6, trailing: 8))
        .background(
            RoundedRectangle(cornerRadius: 8)
                .foregroundColor(vm.isSelectedPeople(item) ? .lightGray03 : .greenTint5)
        )
        .contentShape(Rectangle())
        .onTapGesture {
            vm.onClickPeopleItem(item)
        }
    }
}
