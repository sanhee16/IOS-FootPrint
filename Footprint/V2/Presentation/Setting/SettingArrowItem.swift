//
//  SettingArrowItem.swift
//  Footprint
//
//  Created by sandy on 11/25/24.
//

import SwiftUI

struct SettingArrowItem: View {
    let text: String
    let onTap: () -> ()
    
    init(text: String, onTap: @escaping () -> Void) {
        self.text = text
        self.onTap = onTap
    }
    
    var body: some View {
        HStack(alignment: .center, spacing: 0, content: {
            Text(text)
                .sdFont(.body1, color: .cont_gray_high)
            Spacer()
            Image("ic_arrow_right")
                .resizable()
                .frame(both: 24.0, alignment: .center)
        })
        .sdPaddingVertical(24)
        .contentShape(Rectangle())
        .onTapGesture {
            onTap()
        }
    }
}
