//
//  PeopleWithListView.swift
//  Footprint
//
//  Created by Studio-SJ on 2023/01/05.
//

import SwiftUI

struct PeopleWithListView: View {
    typealias VM = PeopleWithListViewModel
    public static func vc(_ coordinator: AppCoordinator, completion: (()-> Void)? = nil) -> UIViewController {
        let vm = VM.init(coordinator)
        let view = Self.init(vm: vm)
        let vc = BaseViewController.init(view, completion: completion)
        return vc
    }
    @ObservedObject var vm: VM
    
    private var safeTop: CGFloat { get { Util.safeTop() }}
    private var safeBottom: CGFloat { get { Util.safeBottom() }}
    private let imageSize: CGFloat = 36.0
    
    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .leading, spacing: 0) {
                Topbar("함께한 친구 편집하기", type: .back) {
                    vm.onClose()
                }
                VStack(alignment: .center, spacing: 0) {
                    ScrollView(.vertical, showsIndicators: false) {
                        VStack(alignment: .leading, spacing: 6) {
                            ForEach($vm.peopleWithList.wrappedValue.indices, id: \.self) { idx in
                                let item = $vm.peopleWithList.wrappedValue[idx]
                                peopleWithItem(geometry, item: item)
                            }
                        }
                        .padding(EdgeInsets(top: 12, leading: 0, bottom: 20, trailing: 0))
                    }
                }
                .frame(width: geometry.size.width - 24, alignment: .leading)
                .padding([.leading, .trailing], 12)
            }
            .padding(EdgeInsets(top: safeTop, leading: 0, bottom: safeBottom, trailing: 0))
            .edgesIgnoringSafeArea(.all)
            .frame(width: geometry.size.width, alignment: .leading)
        }
        .onAppear {
            vm.onAppear()
        }
    }
    
    private func peopleWithItem(_ geometry: GeometryProxy, item: PeopleWith) -> some View {
        return HStack(alignment: .center, spacing: 14) {
            if let image = ImageManager.shared.getSavedImage(named: item.image) {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .frame(both: imageSize, aligment: .center)
                    .clipShape(Circle())
                    .contentShape(Rectangle())
                    .clipped()
            } else {
                Image("profile")
                    .resizable()
                    .scaledToFit()
                    .frame(both: imageSize, aligment: .center)
                    .clipShape(Circle())
                    .contentShape(Rectangle())
                    .clipped()
                    .background(
                        Circle()
                            .foregroundColor(.lightGray02)
                    )
            }
            Text(item.name)
                .font(.kr14r)
                .foregroundColor(.gray100)
            Spacer()
        }
        .padding(EdgeInsets(top: 6, leading: 8, bottom: 6, trailing: 8))
        .background(
            RoundedRectangle(cornerRadius: 8)
                .foregroundColor(.greenTint5)
        )
        .contentShape(Rectangle())
        .onTapGesture {
            vm.onClickEdit(item)
        }
    }
}
