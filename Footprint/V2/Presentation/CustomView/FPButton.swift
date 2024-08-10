//
//  FPButton.swift
//  Footprint
//
//  Created by sandy on 8/10/24.
//

import Foundation
import SwiftUI


struct FPButton: View {
    enum ImageLocation {
        case leading(name: String)
        case trailing(name: String)
    }
    
    enum ButtonStatus {
        case able
        case press
        case disable
    }
    
    enum ButtonSize {
        case large
        case medium
        case small
    }
    
    enum ButtonType {
        case solid
        case lightSolid
        case outline
        case textPrimary
        case textGray
    }
    
    let text: String
    let location: ImageLocation?
    let status: ButtonStatus
    let size: ButtonSize
    let type: ButtonType
    
    let onTap: ()->()
    
    init(text: String, location: ImageLocation? = nil, status: ButtonStatus, size: ButtonSize, type: ButtonType, onTap: @escaping () -> Void) {
        self.text = text
        self.location = location
        self.status = status
        self.size = size
        self.type = type
        self.onTap = onTap
    }
    
    var body: some View {
        Button(action: {
            self.onTap()
        }, label: {
            HStack(alignment: .center, spacing: 8, content: {
                if case let .leading(name) = location {
                    Image(name)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 24, alignment: .center)
                }
                
                Text(text)
                    .sdFont(.btn1, color: self.textColor)
                
                if case let .trailing(name) = location {
                    Image(name)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 24, alignment: .center)
                }
            })
            .sdPaddingVertical(self.verticalPadding)
            .sdPaddingHorizontal(self.horizontalPadding ?? 0.0)
            .frame(maxWidth: self.horizontalPadding == nil ? .infinity : nil)
            .contentShape(Rectangle())
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .foregroundStyle(self.backgroundColor)
                    .border(self.borderColor, lineWidth: 1.5, cornerRadius: 12)
            )
        })
    }
}

//
//#Preview {
//    VStack(alignment: .leading, spacing: 0, content: {
//        FPButton(text: "hello, world!", status: .disable, size: .large, type: .lightSolid) {
//            
//        }
//        FPButton(text: "hello, world!", status: .press, size: .medium, type: .lightSolid) {
//            
//        }
//        FPButton(text: "hello, world!", status: .able, size: .small, type: .solid) {
//            
//        }
//    })
//}


extension FPButton {
    //TODO: 수정 필요
    var verticalPadding: CGFloat {
        switch self.size {
        case .large:
            return 20
        case .medium:
            return 17
        case .small:
            return 14
        }
    }
    
    var horizontalPadding: CGFloat? {
        switch self.size {
        case .large:
            return nil
        case .medium:
            return 16
        case .small:
            return 16
        }
    }
    
    var textColor: Color {
        switch self.type {
        case .solid:
            switch self.status {
            case .able: return Color(hex: "#FAFAFA")
            case .press: return Color(hex: "#FAFAFA")
            case .disable: return Color(hex: "#FAFAFA")
            }
        case .lightSolid:
            switch self.status {
            case .able: return Color(hex: "#64748B")
            case .press: return Color(hex: "#64748B")
            case .disable: return Color(hex: "#64748B")
            }
        case .outline:
            switch self.status {
            case .able: return Color(hex: "#2955EA")
            case .press: return Color(hex: "#2955EA")
            case .disable: return Color(hex: "#2955EA")
            }
        case .textPrimary:
            switch self.status {
            case .able: return Color(hex: "#2955EA")
            case .press: return Color(hex: "#2955EA")
            case .disable: return Color(hex: "#2955EA")
            }
        case .textGray:
            switch self.status {
            case .able: return Color(hex: "#64748B")
            case .press: return Color(hex: "#64748B")
            case .disable: return Color(hex: "#64748B")
            }
        }
    }
    
    var backgroundColor: Color {
        switch self.type {
        case .solid:
            switch self.status {
            case .able: return Color(hex: "#2955EA")
            case .press: return Color(hex: "#678AFF")
            case .disable: return Color(hex: "#13276C")
            }
        case .lightSolid:
            switch self.status {
            case .able: return Color(hex: "#E2E8F0")
            case .press: return Color(hex: "#F8FAFC")
            case .disable: return Color(hex: "#CBD5E1")
            }
        case .outline:
            switch self.status {
            case .able: return Color(hex: "#F8FAFC")
            case .press: return Color(hex: "#F8FAFC")
            case .disable: return Color(hex: "#E2E8F0")
            }
        case .textPrimary, .textGray:
            return .clear
        }
    }
    
    var borderColor: Color {
        switch self.type {
        case .outline:
            switch self.status {
            case .able: return Color(hex: "#2955EA")
            case .press: return Color(hex: "#678AFF")
            case .disable: return Color(hex: "#94A3B8")
            }
        default: return .clear
        }
    }
}
