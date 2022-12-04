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
            .padding(EdgeInsets(top: safeTop, leading: 0, bottom: safeBottom, trailing: 0))
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
                    Text(item.title)
                        .font(.kr14b)
                        .foregroundColor(Color.gray100)
                        .multilineTextAlignment(.leading)
                        .padding(EdgeInsets(top: 10, leading: 8, bottom: 10, trailing: 8))
                        .frame(width: geometry.size.width - 32, alignment: .leading)
                        .background(
                            RoundedRectangle(cornerRadius: 6)
                                .foregroundColor(.greenTint5)
                        )
                        .contentShape(Rectangle())
                        .padding([.leading, .trailing], 16)
//                            drawPinSelectArea(geometry)
                    HStack(alignment: .center, spacing: 0) {
                        Spacer()
                        Text(item.createdAt.getDate())
                            .font(.kr9r)
                            .foregroundColor(Color.gray60)
                    }
                    .padding([.leading, .trailing], 16)
                    drawImageArea(geometry, item: item)
                    drawCategory(geometry, item: item)
                    Divider()
                        .background(Color.greenTint5)
                        .padding([.top, .bottom], 4)
                        .padding([.leading, .trailing], 16)
                    
                    Text(item.content)
                        .font(.kr12r)
                        .foregroundColor(Color.gray100)
                        .padding(EdgeInsets(top: 12, leading: 10, bottom: 12, trailing: 10))
                        .frame(width: geometry.size.width - 32, alignment: .topLeading)
                        .contentShape(Rectangle())
                        .multilineTextAlignment(.leading)
                        .background(
                            RoundedRectangle(cornerRadius: 2)
                                .foregroundColor(.greenTint5)
                        )
                        .padding([.leading, .trailing], 16)
                }
                .padding(EdgeInsets(top: 14, leading: 0, bottom: 14, trailing: 0))
                .contentShape(Rectangle())
            }
            .frame(width: geometry.size.width, alignment: .leading)
            .contentShape(Rectangle())
        }
        .frame(width: geometry.size.width, alignment: .leading)
        .contentShape(Rectangle())
    }
    
    private func drawHeader(_ geometry: GeometryProxy) -> some View {
        return ZStack(alignment: .leading) {
            Topbar("", type: .back) {
                vm.onClose()
            }
            HStack(alignment: .center, spacing: 0) {
                Spacer()
                Text("추가하기")
                    .font(.kr12r)
                    .foregroundColor(.gray100)
                    .onTapGesture {
                        vm.onClickAddFootprint()
                    }
            }
            .frame(width: geometry.size.width - 32, height: 50, alignment: .center)
        }
        .frame(width: geometry.size.width, height: 50, alignment: .center)
    }
    
    private func drawCategory(_ geometry: GeometryProxy, item: FootPrint) -> some View {
        return HStack(alignment: .center, spacing: 4) {
            if let pinName = PinType(rawValue: item.pinType)?.pinName {
                Image(pinName)
                    .resizable()
                    .frame(both: 18.0, aligment: .center)
            }
            if let category = vm.getCategory(item) {
                Text(category.name)
                    .font(.kr14r)
                    .foregroundColor(.gray100)
            }
            
        }
        .padding(EdgeInsets(top: 3, leading: 16, bottom: 8, trailing: 16))
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
                            .shadow(color: Color.black.opacity(0.6), radius: 3, x: 0.5, y: 2)
                    }
                }
            }
            .padding(EdgeInsets(top: 3, leading: 16, bottom: 8, trailing: 16))
        }
    }
    
    
//    private func drawPinSelectArea(_ geometry: GeometryProxy) -> some View {
//        return ScrollView(.horizontal, showsIndicators: false) {
//            HStack(alignment: .center, spacing: 12) {
//                ForEach($vm.pinList.wrappedValue, id: \.self) { item in
//                    pinItem(item, isSelected: $vm.pinType.wrappedValue == item)
//                }
//            }
//            .padding(EdgeInsets(top: 6, leading: 12, bottom: 6, trailing: 12))
//        }
//    }
    
    private func pinItem(_ item: PinType, isSelected: Bool) -> some View {
        return Image(item.pinName)
            .resizable()
            .scaledToFit()
            .frame(both: 30)
            .padding(10)
            .border(isSelected ? .greenTint4 : .clear, lineWidth: 2, cornerRadius: 12)
            .onTapGesture {
//                vm.onSelectPin(item)
            }
    }
}
