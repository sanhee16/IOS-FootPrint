//
//  SelectFootprintsViewV2.swift
//  Footprint
//
//  Created by sandy on 11/14/24.
//

import SwiftUI
import SDSwiftUIPack
import SDFlowLayout

struct SelectFootprintsViewV2: View {
    @EnvironmentObject var vm: EditTripVM
    @Binding var isPresented: Bool
    let originalFootprints: [TripFootprintEntity]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0, content: {
            drawHeader()
            ScrollView(.vertical, showsIndicators: false, content: {
                VStack(alignment: .leading, spacing: 0, content: {
                    ForEach($vm.footprints.wrappedValue, id: \.self) { item in
                        Item(item: item)
                            .environmentObject(vm)
                            .sdPaddingBottom(16)
                    }
                })
                .sdPaddingHorizontal(16)
                .sdPaddingTop(24)
                .sdPaddingBottom(30)
            })
        })
    }
    
    private func drawHeader() -> some View {
        HStack(alignment: .center, spacing: 0) {
            FPButton(text: "취소", status: .able, size: .small, type: .textPrimary) {
                $vm.footprints.wrappedValue = originalFootprints
                $isPresented.wrappedValue = false
            }
            Spacer()
            Text("발자국 추가하기")
                .sdFont(.headline2, color: .blackGray_900)
            Spacer()
            FPButton(text: "완료", status: .able, size: .small, type: .textPrimary) {
                $isPresented.wrappedValue = false
            }
        }
        .sdPaddingHorizontal(24)
        .sdPaddingTop(26)

    }
    
    private struct Item: View {
        @EnvironmentObject var vm: EditTripVM
        let item: TripFootprintEntity
        
        var body: some View {
            VStack(alignment: .leading, spacing: 0, content: {
                HStack(alignment: .center, spacing: 0, content: {
                    Text(item.title)
                        .sdFont(.headline2, color: Color.cont_gray_default)
                        .lineLimit(1)
                    Spacer()
                    Text("\((item.idx ?? 0) + 1)")
                        .sdFont(.caption, color: item.idx == nil ? Color.clear : Color.white)
                        .sdPadding(top: 5, leading: 8, bottom: 5, trailing: 8)
                        .background(
                            RoundedRectangle(cornerRadius: 999)
                                .foregroundStyle(item.idx == nil ? Color.clear : Color.cont_primary_mid)
                        )
                })
                
                Text(item.content)
                    .sdFont(.body3, color: Color.cont_gray_high)
                    .sdPaddingTop(16)
                    .lineLimit(1)
                
                Text(item.address)
                    .sdFont(.headline4, color: Color.cont_gray_mid)
                    .sdPaddingTop(8)
                    .lineLimit(1)
            })
            .sdPaddingHorizontal(16)
            .sdPaddingVertical(18)
            .frame(maxWidth: .infinity, alignment: .leading)
            .contentShape(Rectangle())
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .foregroundStyle(item.idx == nil ? Color.bg_white : Color.bg_bgb)
            )
            .border(item.idx == nil ? Color.bg_white : Color.cont_primary_mid, lineWidth: 2, cornerRadius: 12)
            .onTapGesture {
                vm.toggleFootprint(item.id)
            }
        }
    }
}
