//
//  TripDetailView.swift
//  Footprint
//
//  Created by sandy on 11/15/24.
//

import SwiftUI
import SDSwiftUIPack
import SDFlowLayout

struct TripDetailView: View {
    struct Output {
        var pop: () -> ()
        var goToEditTrip: () -> ()
    }
    private let output: Output
    @StateObject private var vm: TripDetailVM
    @StateObject private var footprintVM: FootprintVM = FootprintVM()
    @State private var isPresentFootprint: Bool = false
    @State private var selectedId: String? = nil
    
    
    init(id: String, output: Output) {
        _vm = StateObject(wrappedValue: TripDetailVM(id: id))
        self.output = output
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0, content: {
            ZStack(content: {
                Topbar("발자취 상세보기", type: .back) {
                    self.output.pop()
                }
                HStack(alignment: .center, spacing: 0, content: {
                    Spacer()
                    Text("편집")
                        .sdFont(.btn3, color: Color.btn_lightSolid_cont_default)
                        .padding(16)
                        .contentShape(Rectangle())
                        .onTapGesture {
                            self.output.goToEditTrip()
                        }
                })
            })
            
            ScrollViewReader { scrollProxy in
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 10) {
                        
                        Text(vm.title)
                            .sdFont(.headline1, color: Color.cont_gray_default)
                            .sdPadding(top: 16, leading: 0, bottom: 8, trailing: 0)
                        
                        Text(vm.content)
                            .sdFont(.body1, color: Color.cont_gray_default)
                            .sdPadding(top: 16, leading: 0, bottom: 8, trailing: 0)
                        
                        
                        drawTitle("기간")
                        drawPeriod()
                        
                        drawTitle("발자취 컨셉")
                        if let icon = vm.icon {
                            TripIconItem(item: icon)
                                .padding(16)
                        }
                        
                        drawTitle("발자국 모음")
                        ForEach(vm.footprints, id: \.self) { item in
                            drawFootprintItem(item)
                                .onTapGesture {
                                    selectedId = item.id
                                    self.footprintVM.updateId(item.id)
                                    $isPresentFootprint.wrappedValue = true
                                }
                        }
                    }
                    .sdPaddingVertical(4)
                    .sdPaddingHorizontal(16)
                    .background(Color.bg_default)
                }
                .ignoresSafeArea(.keyboard, edges: [.bottom])
            }
        })
        .background(Color.bg_default)
        .navigationBarBackButtonHidden()
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .onAppear(perform: {
            vm.loadData()
        })
        .sheet(isPresented: $isPresentFootprint, onDismiss: {
            selectedId = nil
        }, content: {
            FootprintView(isPresented: $isPresentFootprint, output: FootprintView.Output(pushEditNoteView: {
                
            }), isEditable: false)
            .environmentObject(footprintVM)
            .presentationDetents([.fraction(0.8), .large])
        })
    }
    
    private func drawPeriod() -> some View {
        HStack(alignment: .center,
               spacing: 0,
               content: {
            Text("\(($vm.startAt.wrappedValue).toEditNoteDate)")
                .sdFont(.body1, color: Color.cont_gray_default)
            Spacer()
            Text("~")
            Spacer()
            Text("\(($vm.endAt.wrappedValue).toEditNoteDate)")
                .sdFont(.body1, color: Color.cont_gray_default)
        })
        .sdPaddingVertical(16)
    }
    
    private func drawTitle(_ text: String) -> some View {
        Text(text)
            .sdFont(.headline4, color: Color.zineGray_700)
            .sdPaddingTop(24)
    }
    
    
    private func drawFootprintItem(_ item: TripFootprintEntity) -> some View {
        VStack(alignment: .leading, spacing: 0, content: {
            Text(item.title)
                .sdFont(.headline2, color: Color.cont_gray_default)
                .lineLimit(1)
            
            Text(item.content)
                .sdFont(.body3, color: Color.cont_gray_high)
                .sdPaddingTop(16)
                .lineLimit(1)
        })
        .sdPaddingHorizontal(16)
        .sdPaddingVertical(18)
        .frame(maxWidth: .infinity, alignment: .leading)
        .contentShape(Rectangle())
        .background(
            RoundedRectangle(cornerRadius: 12)
                .foregroundStyle(Color.bg_white)
        )
    }
}

