//
//  MultiMarkerSelectorView.swift
//  Footprint
//
//  Created by sandy on 11/20/24.
//

import SwiftUI


struct MultiMarkerSelectorView: View {
    @StateObject private var vm: MultiMarkerSelectorVM
    let onClickNote: (String) -> ()
    let onClickViewAll: () -> ()
    let onClickAddNote: (Location) -> ()
    
    init(address: String, onClickNote: @escaping (String) -> (), onClickViewAll: @escaping () -> (), onClickAddNote: @escaping (Location) -> ()) {
        _vm = StateObject(
            wrappedValue: MultiMarkerSelectorVM(
                address: address
            )
        )
        self.onClickNote = onClickNote
        self.onClickViewAll = onClickViewAll
        self.onClickAddNote = onClickAddNote
    }
    
    var body: some View {
        VStack(alignment: .center, spacing: 0, content: {
            VStack(alignment: .center, spacing: 0, content: {
                Text($vm.address.wrappedValue)
                    .sdFont(.headline2, color: .btn_text_gray_default)
                    .multilineTextAlignment(.leading)
                    .padding(16)
                    .frame(width: 275, alignment: .leading)
                Rectangle()
                    .foregroundStyle(Color.dim_black_low)
                    .frame(height: 4, alignment: .center)
                
                ForEach($vm.notes.wrappedValue.indices, id: \.self) { idx in
                    Button(action: {
                        self.onClickNote($vm.notes.wrappedValue[idx].id)
                    }, label: {
                        Text($vm.notes.wrappedValue[idx].title)
                            .sdFont(.btn3, color: .btn_text_gray_default)
                            .sdPaddingLeading(16)
                            .sdPaddingVertical(14)
                            .contentShape(Rectangle())
                            .frame(width: 275, alignment: .leading)
                    })
                    
                    if idx < $vm.notes.wrappedValue.count - 1 {
                        Rectangle()
                            .foregroundStyle(Color.dim_black_low)
                            .frame(width: 275, height: 1, alignment: .center)
                    }
                }
                
                if $vm.totalNotes.wrappedValue > 3 {
                    Rectangle()
                        .foregroundStyle(Color.dim_black_low)
                        .frame(width: 275, height: 4, alignment: .center)
                    
                    Button(action: {
                        self.onClickViewAll()
                    }, label: {
                        HStack(alignment: .center, spacing: 12, content: {
                            Image("ic_arrow-to")
                                .resizable()
                                .frame(both: 22.0, alignment: .center)
                            Text("이 위치 발자국 전체보기")
                                .sdFont(.btn3, color: .btn_text_gray_default)
                        })
                        .sdPadding(top: 11, leading: 16, bottom: 11, trailing: 0)
                        .frame(width: 275, alignment: .leading)
                    })
                }
            })
            .frame(width: 275, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .foregroundStyle(Color.white)
            )
            .sdPaddingBottom(16)
            
            Button(action: {
                if let location = $vm.location.wrappedValue {
                    self.onClickAddNote(location)
                }
            }, label: {
                HStack(alignment: .center, spacing: 12, content: {
                    Image("ic_feet")
                        .resizable()
                        .frame(both: 22.0, alignment: .center)
                    Text("여기에 발자국 남기기")
                        .sdFont(.btn3, color: .btn_text_gray_default)
                })
                .sdPadding(top: 11, leading: 16, bottom: 11, trailing: 0)
                .frame(width: 275, alignment: .leading)
                .contentShape(Rectangle())
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .foregroundStyle(Color.white)
                )
            })
        })
        .shadow(color: Color.black.opacity(0.2), radius: 32, x: 0, y: 0)
        .frame(width: 275, alignment: .center)
    }
}
