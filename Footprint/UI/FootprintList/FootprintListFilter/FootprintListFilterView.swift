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
                        HStack(alignment: .center, spacing: 10.0) {
                            ForEach(Array($vm.peopleWithList.wrappedValue.keys), id: \.self) { item in
                                if let value = $vm.peopleWithList.wrappedValue[item] {
                                    drawPeopleWith(item, isSelected: value)
                                }
                            }
                        }
                        .padding(EdgeInsets(top: 2, leading: 12, bottom: 2, trailing: 12))
                    }
                    drawTitle("카테고리")
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(alignment: .center, spacing: 10.0) {
                            ForEach(Array($vm.categoryList.wrappedValue.keys), id: \.self) { item in
                                if let value = $vm.categoryList.wrappedValue[item] {
                                    drawCategoryItem(item, isSelected: value)
                                }
                            }
                        }
                        .padding(EdgeInsets(top: 2, leading: 12, bottom: 2, trailing: 12))
                    }
                    Spacer()
                    HStack(alignment: .center, spacing: 20) {
                        Text("Clear")
                            .font(.kr16r)
                            .foregroundColor(Color.gray60)
                            .frame(width: (geometry.size.width - horizontalPadding * 2 - 20) / 2, height: 45, alignment: .center)
                            .border(.gray60, lineWidth: 2, cornerRadius: 12)
                            .onTapGesture {
                                vm.onClickClear()
                            }
                        Text("Save")
                            .font(.kr16r)
                            .foregroundColor(Color.greenTint1)
                            .frame(width: (geometry.size.width - horizontalPadding * 2 - 20) / 2, height: 45, alignment: .center)
                            .border(.greenTint1, lineWidth: 2, cornerRadius: 12)
                            .onTapGesture {
                                vm.onClickSave()
                            }
                    }
                    .padding(.bottom, 20)
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
            .padding(EdgeInsets(top: 16, leading: 0, bottom: 12, trailing: 0))
    }
    
    private func drawCategoryItem(_ item: Category, isSelected: Bool) -> some View {
        return HStack(alignment: .center, spacing: 6) {
            Image(item.pinType.pinType().pinWhite)
                .resizable()
                .frame(both: 14.0, aligment: .center)
                .colorMultiply(isSelected ? Color(hex: item.pinColor.pinColor().pinColorHex) : .lightGray02)
            Text(item.name)
                .font(.kr12r)
                .foregroundColor(isSelected ? Color(hex: item.pinColor.pinColor().pinColorHex) : .lightGray02)
        }
        .padding(EdgeInsets(top: 8, leading: 12, bottom: 8, trailing: 12))
        .border(
            isSelected ? Color(hex: item.pinColor.pinColor().pinColorHex) : .lightGray02,
            lineWidth: 1.6,
            cornerRadius: 8
        )
        .onTapGesture {
            vm.onClickCategory(item)
        }
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
                .foregroundColor(isSelected ? .greenTint2 : .lightGray02)
        }
        .padding(EdgeInsets(top: 8, leading: 12, bottom: 8, trailing: 12))
        .border(
            isSelected ? .greenTint2 : .lightGray02,
            lineWidth: 1.6,
            cornerRadius: 8
        )
        .onTapGesture {
            vm.onClickPeopleWith(item)
        }
    }
}

