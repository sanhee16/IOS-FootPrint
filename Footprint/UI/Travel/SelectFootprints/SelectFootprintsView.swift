//
//  SelectFootprintsView.swift
//  Footprint
//
//  Created by Studio-SJ on 2023/01/03.
//

import SwiftUI

struct SelectFootprintsView: View {
    typealias VM = SelectFootprintsViewModel
    public static func vc(_ coordinator: AppCoordinator, selectedList: [FootPrint], callback: @escaping ([FootPrint])->(), completion: (()-> Void)? = nil) -> UIViewController {
        let vm = VM.init(coordinator, selectedList: selectedList, callback: callback)
        let view = Self.init(vm: vm)
        let vc = BaseViewController.init(view, completion: completion)
        return vc
    }
    @ObservedObject var vm: VM
    
    private var safeTop: CGFloat { get { Util.safeTop() }}
    private var safeBottom: CGFloat { get { Util.safeBottom() }}
    private let IMAGE_SIZE: CGFloat = 50.0
    
    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .leading, spacing: 0) {
                ZStack(alignment: .leading) {
                    Topbar("All FootPrints", type: .close) {
                        vm.onClose()
                    }
                    HStack(alignment: .center, spacing: 0) {
                        Spacer()
                        Text("완료")
                            .font(.kr12r)
                            .foregroundColor(.textColor1)
                            .onTapGesture {
                                vm.onClickComplete()
                            }
                    }
                    .padding([.leading, .trailing], 12)
                    .frame(width: geometry.size.width - 24, height: 50, alignment: .center)
                }
                .frame(width: geometry.size.width, height: 50, alignment: .center)
                ScrollViewReader { value in
                    ZStack(alignment: .bottomTrailing) {
                        ScrollView(.vertical, showsIndicators: false) {
                            ForEach($vm.list.wrappedValue.indices, id: \.self) { idx in
                                let item = $vm.list.wrappedValue[idx]
                                drawFootprintItem(geometry, item: item)
                            }
                            .padding([.top, .bottom], 16)
                        }
                        .frame(width: geometry.size.width, height: geometry.size.height - safeTop - safeBottom - 50, alignment: .leading)
                    }
                }
            }
            .padding(EdgeInsets(top: safeTop, leading: 0, bottom: safeBottom, trailing: 0))
            .edgesIgnoringSafeArea(.all)
            .frame(width: geometry.size.width, alignment: .leading)
        }
        .onAppear {
            vm.onAppear()
        }
    }
    
    private func drawFootprintItem(_ geometry: GeometryProxy, item: FootPrint) -> some View {
        return VStack(alignment: .leading, spacing: 8) {
            HStack(alignment: .center, spacing: 0) {
                Text(item.title)
                    .font(.kr14b)
                    .foregroundColor(.textColor1)
                Spacer()
                if let idx = vm.selectedIdx(item) {
                    Text("\(idx + 1)")
                        .font(.kr10b)
                        .foregroundColor(.white)
                        .padding(4)
                        .background(
                            Circle()
                                .foregroundColor(.fColor2)
                        )
                }
            }
            .padding([.leading, .trailing], 12)
            
            if let category = item.tag.getCategory() {
                HStack(alignment: .center, spacing: 6) {
                    Image(category.pinType.pinType().pinWhite)
                        .resizable()
                        .frame(both: 18.0, aligment: .center)
                        .colorMultiply(Color(hex: category.pinColor.pinColor().pinColorHex))
                    Text(category.name)
                        .font(.kr12r)
                        .foregroundColor(Color(hex: category.pinColor.pinColor().pinColorHex))
                }
                .padding([.leading, .trailing], 12)
            }
        }
        .padding([.top, .bottom], 16)
        .frame(width: geometry.size.width - 40, alignment: .leading)
        .contentShape(Rectangle())
        .background(
            RoundedRectangle(cornerRadius: 12)
                .foregroundColor(Color.white)
        )
        .border(vm.selectedIdx(item) != nil ? .fColor2 : .clear, lineWidth: 2, cornerRadius: 12)
        .padding([.leading, .trailing], 20)
        .onTapGesture {
            withAnimation {
                vm.onClickItem(item)
            }
        }
    }
    
    private func drawCreatedAt(_ geometry: GeometryProxy, item: FootPrint) -> some View {
        return HStack(alignment: .center, spacing: 4) {
            Image("calendar")
                .resizable()
                .frame(both: 18.0, aligment: .center)
            Text(item.createdAt.getDate())
                .font(.kr11r)
                .foregroundColor(Color.gray90)
        }
    }
    
    private func drawPeopleWith(_ geometry: GeometryProxy, items: [PeopleWith]) -> some View {
        return HStack(alignment: .center, spacing: 4) {
            Image("person")
                .resizable()
                .frame(both: 18.0, aligment: .center)
            HStack(alignment: .center, spacing: 8) {
                ForEach(items, id: \.self) { item in
                    Text(item.name)
                        .font(.kr11r)
                        .foregroundColor(Color.gray90)
                }
            }
        }
    }
}

