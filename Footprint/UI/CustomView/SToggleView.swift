//
//  SToggleView.swift
//  Footprint
//
//  Created by Studio-SJ on 2023/01/05.
//

import Foundation
import SwiftUI

public struct SToggleView: View {
    private let width: CGFloat
    private let height: CGFloat
    private let color: Color
    private let onTapGesture: (()->())?
    @Binding var isOn: Bool
    
    
    init(width: CGFloat = 40.0, height: CGFloat = 22.0, color: Color = Color.fColor3, isOn: Binding<Bool>, onTapGesture: (()->())? = nil) {
        self.width = width
        self.height = height
        self.color = color
        self._isOn = isOn
        self.onTapGesture = onTapGesture
    }
    
    public var body: some View {
        Toggle("", isOn: $isOn)
            .labelsHidden()
            .contentShape(Rectangle())
            .toggleStyle(
                SToggleStyle(width: width, height: height, color: color, onTapGesture: onTapGesture)
            )
    }
    
    struct SToggleStyle: ToggleStyle {
        let width: CGFloat
        let height: CGFloat
        let color: Color
        let onTapGesture: (()->())?
        
        func makeBody(configuration: Configuration) -> some View {
            HStack {
                configuration.label
                ZStack(alignment: configuration.isOn ? .trailing : .leading) {
                    RoundedRectangle(cornerRadius: 20)
                        .frame(width: width, height: height)
                        .foregroundColor(configuration.isOn ? color : .white.opacity(0.5))
                    
                    Circle()
                        .frame(both: height - 5)
                        .padding(2.5)
                        .foregroundColor(configuration.isOn ? .white : .gray60)
                        .onTapGesture {
                            withAnimation {
                                if let onTapGesture = onTapGesture {
                                    onTapGesture()
                                }
                                configuration.$isOn.wrappedValue.toggle()
                            }
                        }
                }
            }
        }
    }
}

