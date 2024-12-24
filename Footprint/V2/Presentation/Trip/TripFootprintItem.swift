//
//  TripFootprintItem.swift
//  Footprint
//
//  Created by sandy on 12/24/24.
//

import SwiftUI
import SDSwiftUIPack

struct TripFootprintItem: View {
    let item: TripFootprintEntity
    
    var body: some View {
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
