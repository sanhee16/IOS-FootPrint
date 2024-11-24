//
//  FootprintListViewV2.swift
//  Footprint
//
//  Created by sandy on 11/18/24.
//

import SwiftUI

struct FootprintListViewV2: View {
    struct Output {
        var goToEditNote: () -> ()
    }
    
    private var output: Output
    
    @EnvironmentObject private var coordinator: FootprintCoordinator
    @StateObject private var vm: FootprintListVMV2 = FootprintListVMV2()
    @StateObject private var footprintVM: FootprintVM = FootprintVM()
    @EnvironmentObject private var tabBarVM: TabBarVM
    @State private var isPresentFootprint: Bool = false
    @State private var selectedId: String? = nil
    
    @State private var isShowSorting: Bool = false
    @State private var sortButtonLocation: CGRect = .zero
    @State private var sortBoxWidth: CGFloat = .zero
    
    init(output: Output) {
        self.output = output
    }
    
    var body: some View {
        NavigationStack(path: $coordinator.paths) {
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
                    Topbar("발자국")
                    
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
                            ForEach($vm.notes.wrappedValue, id: \.self) { item in
                                NoteItem(item: item)
                                    .onTapGesture {
                                        self.selectedId = item.id
                                        self.footprintVM.updateId(item.id)
                                        $isPresentFootprint.wrappedValue = true
                                    }
                                
                            }
                        })
                        .sdPaddingHorizontal(16)
                        .sdPadding(bottom: 40)
                    })
                    .background(Color.bg_default)
                    
                    MainMenuBar(current: .footprints) { type in
                        tabBarVM.onChangeTab(type)
                    }
                })
                .frame(maxWidth: .infinity, alignment: .topLeading)
                .background(Color.bg_default)
                .onAppear {
                    vm.loadData()
                }
            }
            .sheet(isPresented: $isPresentFootprint, onDismiss: {
                $isPresentFootprint.wrappedValue = false
            }, content: {
                FootprintView(isPresented: $isPresentFootprint, output: FootprintView.Output(pushEditNoteView: {
                    if let id = selectedId {
                        vm.updateTempNote(id)
                        self.output.goToEditNote()
                    }
                }))
                .environmentObject(footprintVM)
                .presentationDetents([.fraction(0.8), .large])
            })
            .frame(maxWidth: .infinity, alignment: .center)
            .navigationDestination(for: Destination.self) { destination in
                coordinator.moveToDestination(destination: destination)
            }
        }
    }
    
    private func sortItem(_ item: FootprintSortType, onTap: @escaping () -> ()) -> some View {
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
    
    private struct NoteItem: View {
        let item: NoteEntity
        
        var body: some View {
            VStack(alignment: .leading, spacing: 0, content: {
                HStack(alignment: .center, spacing: 8, content: {
                    CategoryItem(item: item.category)
                    if item.isStar {
                        Image("ic_star")
                            .renderingMode(.template)
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(Color.cont_primary_mid)
                            .frame(both: 16.0, alignment: .center)
                    }
                    Spacer()
                    Text("\(Date(timeIntervalSince1970: Double(item.createdAt)).toEditNoteDate)")
                        .sdFont(.headline4, color: Color.cont_gray_mid)
                })
                .sdPaddingTop(24)
                Text(item.title)
                    .sdFont(.headline2, color: Color.cont_gray_default)
                    .sdPaddingTop(16)
                Text(item.content)
                    .sdFont(.body3, color: Color.cont_gray_mid)
                    .sdPaddingVertical(16)
            })
            .contentShape(Rectangle())
            .background(Color.bg_default)
        }
    }
}

//#Preview {
//    TripListView(output: TripListView.Output{ _ in
//
//    })
//}
