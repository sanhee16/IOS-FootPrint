//
//  SettingToggleItem.swift
//  Footprint
//
//  Created by sandy on 11/25/24.
//

import SwiftUI

struct SettingToggleItem: View {
    let text: String
    @Binding var isOn: Bool
    
    init(text: String, isOn: Binding<Bool>) {
        self.text = text
        self._isOn = isOn
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0, content: {
            HStack(alignment: .center, spacing: 0, content: {
                Text(text)
                    .sdFont(.body1, color: .cont_gray_high)
                Spacer()
                
                Toggle(isOn: $isOn, label: {
                    
                })
                .toggleStyle(SwitchToggleStyle(tint: Color.cont_primary_mid))
            })
            .sdPaddingVertical(24)
            
            Rectangle()
                .frame(height: 0.5)
                .foregroundStyle(Color.dim_black_low)
        })
        .contentShape(Rectangle())
    }
}
