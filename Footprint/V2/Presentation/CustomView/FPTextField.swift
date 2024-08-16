//
//  FPTextField.swift
//  Footprint
//
//  Created by sandy on 8/11/24.
//

import Foundation
import SwiftUI

struct FPTextField: View {
    enum FieldStyle {
        case line
        case box
        case none
    }
    
    enum LineStyle {
        case single(limit: Int?)
        case multi(limit: Int?)
    }
    @FocusState private var isFocused: Bool
    
    let placeHolder: String
    var text: Binding<String>
    let fieldStyle: Self.FieldStyle
    let lineStyle: Self.LineStyle
    let isDisabled: Bool
    
    init(
        placeHolder: String,
        text: Binding<String>,
        fieldStyle: Self.FieldStyle = .line,
        lineStyle: Self.LineStyle = .single(limit: nil),
        isDisabled: Bool = false
    ) {
        self.placeHolder = placeHolder
        self.text = text
        self.fieldStyle = fieldStyle
        self.lineStyle = lineStyle
        self.isDisabled = isDisabled
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0, content: {
            switch self.lineStyle {
            case .single(let limit):
                TextField(placeHolder, text: text)
                    .sdPaddingVertical(10)
                    .focused($isFocused)
                    .background(
                        fieldStyleView()
                    )
                    .contentShape(Rectangle())
                    .disabled(isDisabled)
                    .onChange(of: text.wrappedValue, perform: { value in
                        handleTextChange(value, limit: limit)
                    })
                
            case .multi(let limit):
                TextField(placeHolder, text: text, axis: .vertical)
                    .sdPaddingVertical(10)
                    .focused($isFocused)
                    .background(
                        fieldStyleView()
                    )
                    .contentShape(Rectangle())
                    .disabled(isDisabled)
                    .onChange(of: text.wrappedValue, perform: { value in
                        handleTextChange(value, limit: limit)
                    })
            }
        })
    }
    
    private func handleTextChange(_ value: String, limit: Int?) {
        var newValue = value
        if let limit = limit, value.count > limit {
            newValue.removeLast(value.count - limit)
        }
        text.wrappedValue = newValue
    }
    
    
    @ViewBuilder
    private func fieldStyleView() -> some View {
        switch fieldStyle {
        case .line:
            VStack(alignment: .leading, spacing: 0) {
                Spacer()
                Rectangle()
                    .frame(height: 1.2, alignment: .center)
                    .foregroundStyle(isFocused ? Color.cont_gray_default : Color.dim_black_low)
            }
        case .box:
            RoundedRectangle(cornerRadius: 4)
                .foregroundStyle(Color.white)
                .border(isFocused ? Color.cont_gray_default : Color.dim_black_low, lineWidth: 1.2, cornerRadius: 4)
        default:
            EmptyView()
        }
    }
}
