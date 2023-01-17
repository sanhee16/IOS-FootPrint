//
//  ShowFootPrintView.swift
//  Footprint
//
//  Created by sandy on 2022/11/13.
//

import SwiftUI
import SwiftUIPager
import FittedSheets

struct ShowFootPrintView: View {
    typealias VM = ShowFootPrintViewModel
    public static func vc(_ coordinator: AppCoordinator, location: Location, completion: (()-> Void)? = nil) -> UIViewController {
        let vm = VM.init(coordinator, location: location)
        let view = Self.init(vm: vm)
        let vc = BaseViewController.bottomSheet(view, sizes: [.fixed(500)])
        return vc
    }
    @ObservedObject var vm: VM
    
    private var safeTop: CGFloat { get { Util.safeTop() }}
    private var safeBottom: CGFloat { get { Util.safeBottom() }}
    
    private let IMAGE_SIZE: CGFloat = 70.0
    
    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .leading, spacing: 0) {
                drawHeader(geometry)
                drawBody(geometry)
            }
            .padding(EdgeInsets(top: 0, leading: 0, bottom: safeBottom, trailing: 0))
            .edgesIgnoringSafeArea(.all)
            .frame(width: geometry.size.width, alignment: .leading)
        }
        .onAppear {
            vm.onAppear()
        }
    }
    
    private func drawBody(_ geometry: GeometryProxy) -> some View {
        return Pager(page: $vm.page.wrappedValue, data: $vm.footPrints.wrappedValue, id: \.self) { item in
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 10) {
                    if !item.peopleWithIds.isEmpty {
                        drawPeopleWith(geometry, items: vm.getPeopleWith(Array(item.peopleWithIds)))
                    }
                    drawCategory(geometry, item: item)
                    Text(item.title)
                        .font(.kr14b)
                        .foregroundColor(Color.textColor1)
                        .multilineTextAlignment(.leading)
                        .padding(EdgeInsets(top: 10, leading: 8, bottom: 10, trailing: 8))
                        .frame(width: geometry.size.width - 32, alignment: .leading)
                        .background(
                            RoundedRectangle(cornerRadius: 6)
                                .foregroundColor(.inputBoxColor)
                        )
                        .contentShape(Rectangle())
                        .padding([.leading, .trailing], 16)
                    HStack(alignment: .center, spacing: 0) {
                        Spacer()
                        Text(item.createdAt.getDate())
                            .font(.kr9r)
                            .foregroundColor(Color.gray60)
                    }
                    .padding([.leading, .trailing], 16)
                    drawImageArea(geometry, item: item)
                    Divider()
                        .background(Color.inputBoxColor)
                        .padding([.top, .bottom], 4)
                        .padding([.leading, .trailing], 16)
                    
                    Text(item.content)
                        .font(.kr12r)
                        .foregroundColor(Color.textColor1)
                        .padding(EdgeInsets(top: 12, leading: 10, bottom: 12, trailing: 10))
                        .frame(width: geometry.size.width - 32, alignment: .topLeading)
                        .contentShape(Rectangle())
                        .multilineTextAlignment(.leading)
                        .padding([.leading, .trailing], 16)
                }
                .padding(EdgeInsets(top: 0, leading: 0, bottom: 14, trailing: 0))
                .contentShape(Rectangle())
            }
            .frame(width: geometry.size.width, alignment: .leading)
            .contentShape(Rectangle())
        }
        .disableDragging()
        .frame(width: geometry.size.width, alignment: .leading)
        .contentShape(Rectangle())
    }
    
    private func drawHeader(_ geometry: GeometryProxy) -> some View {
        return ZStack(alignment: .center) {
            Topbar("", type: .back) {
                vm.onClose()
            }
            HStack(alignment: .center, spacing: 6) {
                if $vm.footPrints.wrappedValue.count > 1 {
                    Image("before")
                        .resizable()
                        .frame(both: 16, aligment: .center)
                        .padding(3)
                        .contentShape(Rectangle())
                        .onTapGesture {
                            vm.moveBefore()
                        }
                }
                Text("\($vm.pageIdx.wrappedValue + 1) / \($vm.footPrints.wrappedValue.count)")
                    .font(.kr12r)
                    .foregroundColor(.gray90)
                if $vm.footPrints.wrappedValue.count > 1 {
                    Image("forward")
                        .resizable()
                        .frame(both: 16, aligment: .center)
                        .padding(3)
                        .contentShape(Rectangle())
                        .onTapGesture {
                            vm.moveNext()
                        }
                }
            }
            
            HStack(alignment: .center, spacing: 12) {
                Spacer()
                Text("수정")
                    .font(.kr12r)
                    .foregroundColor(.textColor1)
                    .onTapGesture {
                        vm.onClickModifyFootprint()
                    }
                Text("추가")
                    .font(.kr12r)
                    .foregroundColor(.textColor1)
                    .onTapGesture {
                        vm.onClickAddFootprint()
                    }
            }
            .frame(width: geometry.size.width - 24, height: 50, alignment: .center)
        }
        .frame(width: geometry.size.width, height: 50, alignment: .center)
    }
    
    private func drawPeopleWith(_ geometry: GeometryProxy, items: [PeopleWith]) -> some View {
        return HStack(alignment: .top, spacing: 4) {
            Image("person")
                .resizable()
                .frame(both: 14.0, aligment: .center)
            Text(Util.makePeopleWithNameString(items))
                .font(.kr11r)
                .foregroundColor(Color.gray90)
                .multilineTextAlignment(.leading)
                .lineLimit(nil)
//            LazyVGrid(columns: [GridItem(.adaptive(minimum: 70.0), spacing: 8, alignment: .leading)]) {
//                ForEach(items, id: \.self) { item in
//                    Text(item.name)
//                        .font(.kr11r)
//                        .foregroundColor(Color.gray90)
//                        .lineLimit(1)
//                }
//            }
//            HStack(alignment: .center, spacing: 8) {
//                ForEach(items, id: \.self) { item in
//                    Text(item.name)
//                        .font(.kr11r)
//                        .foregroundColor(Color.gray90)
//                }
//            }
        }
        .padding(EdgeInsets(top: 0, leading: 16, bottom: 2, trailing: 0))
    }
    
    
    private func drawCategory(_ geometry: GeometryProxy, item: FootPrint) -> some View {
        return HStack(alignment: .center, spacing: 4) {
            if let category = item.tag.getCategory() {
                Image(category.pinType.pinType().pinWhite)
                    .resizable()
                    .frame(both: 14.0, aligment: .center)
                    .colorMultiply(Color(hex: category.pinColor.pinColor().pinColorHex))
                Text(category.name)
                    .font(.kr11r)
                    .foregroundColor(Color.gray90)
            }
        }
        .padding(EdgeInsets(top: 0, leading: 16, bottom: 8, trailing: 0))
    }
    
    private func drawImageArea(_ geometry: GeometryProxy, item: FootPrint) -> some View {
        return ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(item.images.indices, id: \.self) { idx in
                    if let dir = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false),
                       let uiImage = UIImage(contentsOfFile: URL(fileURLWithPath: dir.absoluteString).appendingPathComponent(item.images[idx]).path) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFill()
                            .frame(both: IMAGE_SIZE)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                            .contentShape(Rectangle())
                            .shadow(color: Color.black.opacity(0.3), radius: 2, x: 0.5, y: 0.5)
                            .onTapGesture {
                                vm.showImage(idx)
                            }
                    }
                }
            }
            .padding(EdgeInsets(top: 3, leading: 16, bottom: 8, trailing: 16))
        }
    }
    
//    private func pinItem(_ item: PinType, isSelected: Bool) -> some View {
//        return Image(item.pinName)
//            .resizable()
//            .scaledToFit()
//            .frame(both: 30)
//            .padding(10)
//            .border(isSelected ? .fColor3 : .clear, lineWidth: 2, cornerRadius: 12)
//            .onTapGesture {
//                //                vm.onSelectPin(item)
//            }
//    }
}
