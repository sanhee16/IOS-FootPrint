//
//  FootprintListWtihSameAddressView.swift
//  Footprint
//
//  Created by sandy on 12/23/24.
//

import SwiftUI

struct FootprintListWtihSameAddressView: View {
    struct Output {
        var goToEditNote: (EditNoteType) -> ()
        var pop: () -> ()
    }
    
    private var output: Output
    
    @StateObject private var vm: FootprintListWtihSameAddressVM
    @StateObject private var footprintVM: FootprintVM = FootprintVM()
    @EnvironmentObject private var tabBarVM: TabBarVM
    @State private var isPresentFootprint: Bool = false
    @State private var selectedId: String? = nil
    
    @State private var isShowSorting: Bool = false
    @State private var sortButtonLocation: CGRect = .zero
    @State private var sortBoxWidth: CGFloat = .zero
    
    init(output: Output, address: String) {
        self.output = output
        self._vm = .init(wrappedValue: FootprintListWtihSameAddressVM(address: address))
    }
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            VStack(alignment: .leading, spacing: 0, content: {
                Topbar("이 위치 발자국 전체보기", type: .back) {
                    self.output.pop()
                }
                
                Text(vm.address)
                    .font(.headline4)
                    .foregroundStyle(Color.cont_gray_mid)
                    .frame(maxWidth: .infinity)
                    .frame(height: 64, alignment: .center)
                
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
            FootprintView(isPresented: $isPresentFootprint, output: FootprintView.Output(pushUpdateNoteView: { id in
                vm.clearTempNote()
                self.output.goToEditNote(.update(id: id))
            }, pushCreateNoteView: { location, address in
                vm.clearTempNote()
                self.output.goToEditNote(.create(address: address, location: location))
            }, pushFootprintListWtihSameAddressView: { address in

            }))
            .environmentObject(footprintVM)
            .presentationDetents([.fraction(0.8), .large])
        })
        .frame(maxWidth: .infinity, alignment: .center)
        .navigationBarBackButtonHidden()
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
                    .lineLimit(1)
                    .sdFont(.headline2, color: Color.cont_gray_default)
                    .sdPaddingTop(16)
                Text(item.content)
                    .lineLimit(1)
                    .sdFont(.body3, color: Color.cont_gray_mid)
                    .sdPaddingVertical(16)
            })
            .contentShape(Rectangle())
            .background(Color.bg_default)
        }
    }
}
