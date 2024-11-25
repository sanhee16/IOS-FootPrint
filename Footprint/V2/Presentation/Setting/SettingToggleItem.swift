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
        HStack(alignment: .center, spacing: 0, content: {
            Text(text)
                .sdFont(.body1, color: .cont_gray_high)
            Spacer()
            
            Toggle(isOn: $isOn, label: {
                
            })
            .toggleStyle(SwitchToggleStyle(tint: Color.cont_primary_mid))
        })
        .sdPadding(top: 24, leading: 0, bottom: 16, trailing: 0)
        .contentShape(Rectangle())
    }
}
