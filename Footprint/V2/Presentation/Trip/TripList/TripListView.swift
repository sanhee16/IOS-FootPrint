//
//  TripListView.swift
//  Footprint
//
//  Created by sandy on 11/12/24.
//

import SwiftUI

struct TripListView: View {
    struct Output {
        var goToEditTrip: (EditTripType) -> ()
        var goToTripDetail: (String) -> ()
    }
    
    private var output: Output
    @EnvironmentObject private var tabBarService: TabBarService
    @StateObject private var vm: TripListVM = TripListVM()
    @State private var isShowSorting: Bool = false
    @State private var sortButtonLocation: CGRect = .zero
    @State private var sortBoxWidth: CGFloat = .zero
    
    init(output: Output) {
        self.output = output
    }
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            if isShowSorting {
                ZStack(alignment: .bottom, content: {
                    VStack(alignment: .leading, spacing: 0, content: {
                        ForEach(vm.sortTypes.indices, id: \.self) { idx in
                            sortItem(vm.sortTypes[idx]) {
                                vm.onSelectSortType(vm.sortTypes[idx]) {
                                    isShowSorting = false
                                }
                            }
                            if idx < vm.sortTypes.count - 1 {
                                Rectangle()
                                    .frame(height: 0.5)
                                    .foregroundStyle(Color.dim_black_low)
                            }
                        }
                        .frame(width: 187, alignment: .leading)
                    })
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .foregroundStyle(Color.white)
                    )
                    .background(
                        GeometryReader { geometry in
                            Color.clear
                                .onAppear {
                                    self.sortBoxWidth = geometry.size.height
                                }
                        }
                    )
                    .zIndex(3)
                    .shadow(color: Color.black.opacity(0.2), radius: 32, x: 0, y: 0)
                    .offset(
                        x: -16,
                        y: $sortButtonLocation.wrappedValue.minY
                    )
                })
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                .zIndex(2)
                .background(Color.clear)
                .contentShape(Rectangle())
                .onTapGesture {
                    isShowSorting = false
                }
            }
            VStack(alignment: .leading, spacing: 0, content: {
                Topbar("발자취")
                HStack(alignment: .center, spacing: 0, content: {
                    Spacer()
                    FPButton(text: "정렬", location: .leading(name: "ic_arrow_transfer"), status: .able, size: .small, type: .textGray) {
                        isShowSorting.toggle()
                    }
                    .sdPadding(top: 4, leading: 6, bottom: 4, trailing: 6)
                    .rectReader($sortButtonLocation, in: .global)
                })
                ScrollView(.vertical, showsIndicators: false, content: {
                    VStack(alignment: .leading, spacing: 0, content: {
                        ForEach($vm.trips.wrappedValue, id: \.self) { item in
                            TripItem(item: item)
                                .onTapGesture {
                                    self.output.goToTripDetail(item.id)
                                }
                        }
                    })
                    .sdPaddingHorizontal(16)
                })
            })
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            .background(Color.bg_default)
            .onAppear {
                vm.loadData()
            }
            
            VStack(alignment: .leading, spacing: 0, content: {
                Spacer()
                HStack(alignment: .center, spacing: 0, content: {
                    Spacer()
                    FPButton(text: "발자취 만들기", location: .leading(name: "arrow-roadmap"), status: .able, size: .medium, type: .solid) {
                        self.output.goToEditTrip(.create)
                    }
                    .shadow(color: Color.dropSahdow_primary_low.opacity(0.15), radius: 4, x: 0, y: 2)
                    .padding(16)
                    .zIndex(1)
                })
            })
        }
    }
    
    private func sortItem(_ item: TripSortType, onTap: @escaping () -> ()) -> some View {
        HStack(alignment: .center, spacing: 4, content: {
            if $vm.sortType.wrappedValue == item {
                Image("ic_check")
                    .resizable()
                    .frame(both: 16, alignment: .center)
            }
            Text(item.text)
                .sdFont(.btn3, color: Color.btn_text_gray_default)
            Spacer()
        })
        .sdPadding(top: 14, leading: 16, bottom: 14, trailing: 16)
        .frame(maxWidth: .infinity)
        .contentShape(Rectangle())
        .onTapGesture {
            onTap()
        }
    }
    
    private struct TripItem: View {
        let item: TripEntity
        @State private var contentHeight: CGFloat = .zero
        
        var body: some View {
            VStack(alignment: .leading, spacing: 0, content: {
                HStack(alignment: .center, spacing: 8, content: {
                    ZStack(alignment: .center, content: {
                        Image(item.icon.icon.imageName)
                            .resizable()
                            .frame(both: 24.0)
                            .zIndex(1)
                        
                        Circle()
                            .frame(both: 44.0)
                            .foregroundStyle(Color.bg_white)
                            .border(Color.cont_primary_low, lineWidth: 1, cornerRadius: 999)
                    })
                    .frame(both: 44.0)
                    
                    Text(item.title)
                        .sdFont(.headline2, color: Color.cont_gray_default)
                        .lineLimit(1)
                    Spacer()
                })
                
                HStack(alignment: .center, spacing: 8, content: {
                    ZStack(alignment: .bottom, content: {
                        VStack(alignment: .center, spacing: 0, content: {
                            DottedLine()
                                .stroke(style: StrokeStyle(lineWidth: 1, dash: [4]))
                                .frame(width: 1, height: self.contentHeight)
                                .foregroundColor(Color.dropSahdow_primary_low)
                                .frame(width: 44, alignment: .center)
                            Spacer()
                        })
                        
                        Image("line-Img")
                            .resizable()
                            .scaledToFit()
                            .scaleEffect(x: -1, y: 1)
                            .frame(width: 26)
                            .zIndex(1)
                    })
                    
                    Text(item.content)
                        .sdFont(.body3, color: Color.cont_gray_mid)
                        .lineLimit(4)
                        .frame(minHeight: 46, alignment: .topLeading)
                        .sdPaddingTop(4)
                        .sdPaddingBottom(24)
                })
                .background(
                    GeometryReader { geometry in
                        Color.clear
                            .onAppear {
                                self.contentHeight = geometry.size.height - 10.0
                            }
                    }
                )
                
                HStack(alignment: .center, spacing: 8, content: {
                    Image("line-Img")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 44)
                    
                    VStack(alignment: .leading, spacing: 8, content: {
                        HStack(alignment: .center, spacing: 4, content: {
                            if let first = item.footprints.first {
                                Text(first.title)
                                    .sdFont(.headline4, color: Color.cont_gray_mid)
                            }
                            if item.footprints.count >= 2 {
                                Text("외 \(item.footprints.count - 1)개의 발자국")
                                    .sdFont(.headline4, color: Color.cont_gray_mid)
                            }
                        })
                        Text(Date(timeIntervalSince1970: Double(item.startAt)).toEditNoteDate + "~" + Date(timeIntervalSince1970: Double(item.endAt)).toEditNoteDate)
                            .sdFont(.headline4, color: Color.cont_gray_mid)
                    })
                })
            })
            .sdPaddingVertical(16)
            .contentShape(Rectangle())
        }
        
        struct DottedLine: Shape {
            func path(in rect: CGRect) -> Path {
                var path = Path()
                path.move(to: CGPoint(x: 0, y: 0))
                path.addLine(to: CGPoint(x: rect.width, y: rect.height))
                return path
            }
        }
        
    }
}

//#Preview {
//    TripListView(output: TripListView.Output{ _ in
//        
//    })
//}
