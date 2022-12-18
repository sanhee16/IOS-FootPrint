//
//  FootprintListFilterView.swift
//  Footprint
//
//  Created by sandy on 2022/12/18.
//


import SwiftUI

struct FootprintListFilterView: View {
    typealias VM = FootprintListFilterViewModel
    public static func vc(_ coordinator: AppCoordinator, completion: (()-> Void)? = nil) -> UIViewController {
        let vm = VM.init(coordinator)
        let view = Self.init(vm: vm)
        let vc = BaseViewController.bottomSheet(view, sizes: [.fixed(400.0)])
        return vc
    }
    @ObservedObject var vm: VM
    
    private var safeTop: CGFloat { get { Util.safeTop() }}
    private var safeBottom: CGFloat { get { Util.safeBottom() }}
    
    private let horizontalPadding: CGFloat = 12.0
    
    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .leading, spacing: 0) {
                Topbar("", type: .close) {
                    vm.onClose()
                }
                VStack(alignment: .leading, spacing: 0) {
                    drawTitle("함께한 사람")
                    ScrollView(.horizontal, showsIndicators: false) {
                        LazyHGrid(rows: Array(repeating: .init(.flexible(), spacing: 10.0), count: 3), alignment: .center, spacing: 10.0) {
                            ForEach(Array($vm.peopleWithList.wrappedValue.keys), id: \.self) { item in
                                if let value = $vm.peopleWithList.wrappedValue[item] {
                                    drawPeopleWith(item, isSelected: value)
                                }
                            }
                        }
                    }
                    drawTitle("카테고리")
                    ScrollView(.horizontal, showsIndicators: false) {
                        LazyHGrid(rows: Array(repeating: .init(.flexible(), spacing: 10.0), count: 3), alignment: .center, spacing: 10.0) {
                            ForEach(Array($vm.categoryList.wrappedValue.keys), id: \.self) { item in
                                if let value = $vm.categoryList.wrappedValue[item] {
                                    drawCategoryItem(item, isSelected: value)
                                }
                            }
                        }
                    }
                }
                .frame(width: geometry.size.width - horizontalPadding * 2, height: 400 - 50, alignment: .center)
            }
            .ignoresSafeArea(.container, edges: [.top, .bottom])
            .frame(width: geometry.size.width, alignment: .leading)
            .background(Color.white)
            .padding([.leading, .trailing], horizontalPadding)
        }
        .onAppear {
            vm.onAppear()
        }
    }
    
    private func drawTitle(_ title: String) -> some View {
        return Text(title)
            .font(.kr13b)
            .foregroundColor(.gray100)
    }
    
    private func drawCategoryItem(_ item: Category, isSelected: Bool) -> some View {
        return HStack(alignment: .center, spacing: 6) {
            Image(item.pinType.pinType().pinWhite)
                .resizable()
                .frame(both: 14.0, aligment: .center)
                .colorMultiply(Color(hex: item.pinColor.pinColor().pinColorHex))
            Text(item.name)
                .font(.kr12r)
                .foregroundColor(isSelected ? Color(hex: item.pinColor.pinColor().pinColorHex) : .lightGray01)
        }
        .padding(EdgeInsets(top: 4, leading: 6, bottom: 4, trailing: 6))
        .border(
            isSelected ? Color(hex: item.pinColor.pinColor().pinColorHex) : .lightGray01,
            lineWidth: 1.4,
            cornerRadius: 8
        )
    }
    
    private func drawPeopleWith(_ item: PeopleWith, isSelected: Bool) -> some View {
        return HStack(alignment: .center, spacing: 6) {
//            if let uiImage = ImageManager.shared.getSavedImage(named: item.image) {
//                Image(uiImage: uiImage)
//                    .resizable()
//                    .scaledToFit()
//                    .frame(both: 8.0, aligment: .center)
//                    .clipShape(Circle())
//                    .contentShape(Rectangle())
//                    .clipped()
//            }
            Text(item.name)
                .font(.kr12r)
                .foregroundColor(isSelected ? .greenTint5 : .lightGray01)
        }
        .padding(EdgeInsets(top: 4, leading: 6, bottom: 4, trailing: 6))
        .border(
            isSelected ? .greenTint5 : .lightGray01,
            lineWidth: 1.4,
            cornerRadius: 8
        )
    }
}

