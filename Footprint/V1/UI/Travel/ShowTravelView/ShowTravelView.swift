//
//  ShowTravelView.swift
//  Footprint
//
//  Created by sandy on 2023/01/08.
//

import SwiftUI
import SDSwiftUIPack
import UniformTypeIdentifiers

struct ShowTravelView: View {
    typealias VM = ShowTravelViewModel
    public static func vc(_ coordinator: AppCoordinator, travel: Travel, completion: (()-> Void)? = nil) -> UIViewController {
        let vm = VM.init(coordinator, travel: travel)
        let view = Self.init(vm: vm)
        let vc = BaseViewController.init(view, completion: completion)
        return vc
    }
    @ObservedObject var vm: VM
    
    private var safeTop: CGFloat { get { Util.safeTop() }}
    private var safeBottom: CGFloat { get { Util.safeBottom() }}
    //    private let IMAGE_SIZE: CGFloat = 50.0
    
    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .leading, spacing: 0) {
                ZStack(alignment: .center) {
                    Topbar($vm.travel.wrappedValue.title, type: .back) {
                        vm.onClose()
                    }
                    HStack(alignment: .center, spacing: 16) {
                        Spacer()
                        Text("delete".localized())
                            .menuText()
                            .onTapGesture {
                                vm.onClickDeleteTravel()
                            }
                        Text("edit".localized())
                            .menuText()
                            .onTapGesture {
                                vm.onClickEdit()
                            }
                    }
                    .menuView()
                }
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
        return VStack(alignment: .leading, spacing: 10) {
            HStack(alignment: .center, spacing: 0) {
                VStack(alignment: .leading, spacing: 10) {
                    Text(vm.travel.title)
                        .font(.kr13b)
                        .foregroundColor(.textColor1)
                    if !vm.travel.intro.isEmpty {
                        Text(vm.travel.intro)
                            .font(.kr13r)
                            .foregroundColor(.gray90)
                    }
                }
                Spacer()
                Circle()
                    .frame(both: 24.0)
                    .foregroundColor(Color(hex: vm.travel.color))
            }
            .padding([.leading, .trailing], 16)
            
            ScrollView(.vertical, showsIndicators: false) {
                ForEach($vm.footprints.wrappedValue.indices, id: \.self) { idx in
                    let item = $vm.footprints.wrappedValue[idx]
                    FootprintItem(geometry: geometry, horizontalPadding: 16.0, item: item, isExpanded: $vm.expandedItem.wrappedValue == item, peopleWiths: vm.getPeopleWiths(Array(item.peopleWithIds))) { idx in
                        vm.showImage(idx)
                    } onClickItem: {
                        vm.onClickItem(item)
                    }
                }
                .padding([.top, .bottom], 16)
            }
            //            .frame(width: geometry.size.width, height: geometry.size.height - 50, alignment: .leading)
        }
    }
}
