//
//  FootprintListView.swift
//  Footprint
//
//  Created by sandy on 2022/12/10.
//


import SwiftUI

struct FootprintListView: View {
    typealias VM = FootprintListViewModel
    public static func vc(_ coordinator: AppCoordinator, completion: (()-> Void)? = nil) -> UIViewController {
        let vm = VM.init(coordinator)
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
                    Topbar("All FootPrints", type: .none)
                    HStack(alignment: .center, spacing: 0) {
                        Spacer()
                        Text("필터")
                            .font(.kr12r)
                            .foregroundColor(.textColor1)
                            .onTapGesture {
                                vm.onClickFilter()
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
                        .frame(width: geometry.size.width, height: geometry.size.height - 50 - 60, alignment: .leading)
                        
                        // TODO: 뺄지 말지 결정하기
                        Image("up_arrow")
                            .resizable()
                            .scaledToFit()
                            .frame(both: 24.0, aligment: .center)
                            .padding(10)
                            .background(
                                Circle()
                                    .foregroundColor(.gray30)
                            )
                            .padding(EdgeInsets(top: 0, leading: 0, bottom: 24, trailing: 24))
                            .zIndex(1)
                            .onTapGesture {
                                value.scrollTo(0, anchor: .top)
                            }
                    }
                }
                MainMenuBar(geometry: geometry, current: .footprints) { type in
                    vm.onClickMenu(type)
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
                Image($vm.expandedItem.wrappedValue == item ? "up_arrow" : "down_arrow")
                    .resizable()
                    .scaledToFit()
                    .frame(both: 16.0, aligment: .center)
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
            if $vm.expandedItem.wrappedValue == item {
                VStack(alignment: .leading, spacing: 8) {
                    drawPeopleWith(geometry, items: vm.getPeopleWiths(Array(item.peopleWithIds)))
                    drawCreatedAt(geometry, item: item)
                }
                .padding([.leading, .trailing], 12)
                
                if !item.images.isEmpty {
                    drawImageArea(geometry, item: item)
                }
                Text(item.content)
                    .font(.kr13r)
                    .foregroundColor(.gray90)
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
        return HStack(alignment: .top, spacing: 4) {
            Image("person")
                .resizable()
                .frame(both: 18.0, aligment: .center)
            
            Text(Util.makePeopleWithNameString(items))
                .font(.kr11r)
                .foregroundColor(Color.gray90)
                .multilineTextAlignment(.leading)
                .lineLimit(nil)
//            HStack(alignment: .center, spacing: 8) {
//                ForEach(items, id: \.self) { item in
//                    Text(Util.makePeopleWithNameString(items))
//                        .font(.kr11r)
//                        .foregroundColor(Color.gray90)
//                }
//            }
        }
    }

    private func drawImageArea(_ geometry: GeometryProxy, item: FootPrint) -> some View {
        return ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(item.images.indices, id: \.self) { idx in
                    if let dir = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false),
                       let uiImage = UIImage(contentsOfFile: URL(fileURLWithPath: dir.absoluteString).appendingPathComponent(item.images[idx]).path) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFill()
                            .frame(both: IMAGE_SIZE)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .contentShape(Rectangle())
                            .shadow(color: Color.black.opacity(0.3), radius: 2, x: 0.5, y: 0.5)
                            .onTapGesture {
                                vm.showImage(idx)
                            }
                    }
                }
            }
            .padding(EdgeInsets(top: 3, leading: 12, bottom: 8, trailing: 12))
        }
    }

}

