//
//  TravelListView.swift
//  Footprint
//
//  Created by Studio-SJ on 2022/12/27.
//

import SwiftUI

struct TravelListView: View {
    typealias VM = TravelListViewModel
    public static func vc(_ coordinator: AppCoordinator, completion: (()-> Void)? = nil) -> UIViewController {
        let vm = VM.init(coordinator)
        let view = Self.init(vm: vm)
        let vc = BaseViewController.init(view, completion: completion)
        return vc
    }
    @ObservedObject var vm: VM
    @Namespace private var topID
    
    private var safeTop: CGFloat { get { Util.safeTop() }}
    private var safeBottom: CGFloat { get { Util.safeBottom() }}
    
    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .leading, spacing: 0) {
                Topbar("travel_list".localized(), type: .none)
                ScrollViewReader { scrollProxy in
                    ZStack(alignment: .bottomTrailing) {
                        ScrollView(.vertical, showsIndicators: false) {
                            VStack(alignment: .leading, spacing: 12) {
                                HStack{}.id(topID)
                                ForEach($vm.travels.wrappedValue.indices, id: \.self) { idx in
                                    let item = $vm.travels.wrappedValue[idx]
                                    drawTravelItem(geometry, item: item)
                                }
                                drawAddNewItem(geometry)
                            }
                            .padding(EdgeInsets(top: 0, leading: 12, bottom: 30, trailing: 20))
                        }
                        .frame(width: geometry.size.width, height: geometry.size.height - 50, alignment: .leading)
                        
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
                                withAnimation {
                                    scrollProxy.scrollTo(topID, anchor: .top)
                                }
                            }
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
    
    private func drawTravelItem(_ geometry: GeometryProxy, item: Travel) -> some View {
        return VStack(alignment: .leading, spacing: 2) {
            VStack(alignment: .leading, spacing: 1) {
                Text(item.title)
                    .font(.kr14b)
                    .foregroundColor(.textColor1)
                
                if !item.intro.isEmpty {
                    Text(item.intro)
                        .font(.kr12r)
                        .foregroundColor(.gray90)
                        .lineLimit(3)
                        .multilineTextAlignment(.leading)
                }
            }
            .padding(.bottom, 4)
            
            HStack(alignment: .center, spacing: 2) {
                Text(item.fromDate.getDate())
                    .font(.kr12r)
                    .foregroundColor(.gray90)
                Image("right_arrow_black")
                    .resizable()
                    .renderingMode(.template)
                    .foregroundColor(.gray90)
                    .scaledToFit()
                    .frame(width: 20.0, height: 12.0, alignment: .center)
                Text(item.toDate.getDate())
                    .font(.kr12r)
                    .foregroundColor(.gray90)
            }
            Text("schedule_count".localized("\(item.footprints.count)"))
                .font(.kr12r)
                .foregroundColor(.gray90)
        }
        .padding(EdgeInsets(top: 16, leading: 12, bottom: 16, trailing: 12))
        .contentShape(Rectangle())
        .frame(
            minWidth:  geometry.size.width - 24, idealWidth:  geometry.size.width - 24, maxWidth: geometry.size.width - 24,
            minHeight: 100, idealHeight: nil, maxHeight: nil, alignment: .leading
        )
        .background(
            RoundedRectangle(cornerRadius: 12)
                .foregroundColor(Color(hex: item.color))
        )
        .onTapGesture {
            vm.onClickShowTravel(item)
        }
    }
    
    private func drawAddNewItem(_ geometry: GeometryProxy) -> some View {
        return VStack(alignment: .center, spacing: 6) {
            Text("+")
                .font(.kr30b)
                .foregroundColor(.white)
        }
        .padding(EdgeInsets(top: 4, leading: 6, bottom: 4, trailing: 6))
        .contentShape(Rectangle())
        .frame(width: geometry.size.width - 24, height: 100, alignment: .center)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .foregroundColor(.textColor3)
        )
        .onTapGesture {
            vm.onClickCreateTravel()
        }
    }
}
