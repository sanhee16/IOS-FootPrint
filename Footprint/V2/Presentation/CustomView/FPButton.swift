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
                        .frame(width: self.imageSize, alignment: .center)
                }
                
                Text(text)
                    .sdFont(self.font, color: self.textColor)
                
                if case let .trailing(name) = location {
                    Image(name)
                        .resizable()
                        .scaledToFit()
                        .frame(width: self.imageSize, alignment: .center)
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
        .disabled(status == .disable)
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
            return 12
        }
    }
    
    var imageSize: CGFloat? {
        switch self.size {
        case .large:
            return 24
        case .medium:
            return 24
        case .small:
            switch self.type {
            case .solid, .lightSolid, .outline:
                return 20
            case .textPrimary, .textGray:
                return 16
            }
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
    
    var font: Font {
        switch self.size {
        case .large:
            return .btn1
        case .medium:
            return .btn2
        case .small:
            switch self.type {
            case .solid, .lightSolid, .outline:
                return .btn2
            case .textPrimary, .textGray:
                return .btn3
            }
        }
    }
    
    var textColor: Color {
        switch self.type {
        case .solid:
            switch self.status {
            case .able: return Color.btn_solid_cont_default
            case .press: return Color.btn_solid_cont_press
            case .disable: return Color.btn_solid_cont_disable
            }
        case .lightSolid:
            switch self.status {
            case .able: return Color.btn_lightSolid_cont_default
            case .press: return Color.btn_lightSolid_cont_press
            case .disable: return Color.btn_lightSolid_cont_disable
            }
        case .outline:
            switch self.status {
            case .able: return Color.btn_outline_cont_default
            case .press: return Color.btn_outline_cont_press
            case .disable: return Color.btn_outline_cont_disable
            }
        case .textPrimary:
            switch self.status {
            case .able: return Color.btn_outline_cont_default
            case .press: return Color.btn_outline_cont_press
            case .disable: return Color.btn_outline_cont_disable
            }
        case .textGray:
            switch self.status {
            case .able: return Color.btn_lightSolid_cont_default
            case .press: return Color.btn_text_gray_press
            case .disable: return Color.btn_lightSolid_cont_disable
            }
        }
    }
    
    var backgroundColor: Color {
        switch self.type {
        case .solid:
            switch self.status {
            case .able: return Color.btn_solid_bg_default
            case .press: return Color.btn_solid_bg_press
            case .disable: return Color.btn_solid_bg_disable
            }
        case .lightSolid:
            switch self.status {
            case .able: return Color.btn_lightSolid_bg_default
            case .press: return Color.btn_lightSolid_bg_press
            case .disable: return Color.btn_lightSolid_bg_disable
            }
        case .outline:
            switch self.status {
            case .able: return Color.btn_outline_bg_default
            case .press: return Color.btn_outline_bg_press
            case .disable: return Color.btn_outline_bg_disable
            }
        case .textPrimary, .textGray:
            return .clear
        }
    }
    
    var borderColor: Color {
        switch self.type {
        case .outline:
            switch self.status {
            case .able: return Color.btn_outline_stroke_default
            case .press: return Color.btn_outline_stroke_press
            case .disable: return Color.btn_outline_stroke_disable
            }
        default: return .clear
        }
    }
}
