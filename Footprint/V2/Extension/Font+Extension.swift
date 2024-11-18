//
//  Font+Extension.swift
//  Footprint
//
//  Created by sandy on 8/10/24.
//

import Foundation
import UIKit
import SwiftUI

extension Font {
    public static let headline1: Font = FPFont.regular(size: 21).font
    public static let headline2: Font = FPFont.bold(size: 16).font
    public static let headline3: Font = FPFont.bold(size: 14).font
    public static let headline4: Font = FPFont.regular(size: 12).font
    public static let body1: Font = FPFont.regular(size: 16).font
    public static let body2: Font = FPFont.regular(size: 15).font
    public static let body3: Font = FPFont.regular(size: 14).font
    public static let callout: Font = FPFont.regular(size: 15).font
    public static let subhead: Font = FPFont.regular(size: 14).font
    public static let footnote: Font = FPFont.regular(size: 12).font
    public static let caption1: Font = FPFont.regular(size: 11).font
    public static let caption2: Font = FPFont.regular(size: 10).font
    
    
    public static let btn1: Font = FPFont.bold(size: 17).font
    public static let btn2: Font = FPFont.bold(size: 16).font
    public static let btn3: Font = FPFont.regular(size: 15).font
}

enum FPFont {
    case regular(size: CGFloat)
    case bold(size: CGFloat)
    case light(size: CGFloat)
    
    var font: Font {
        switch self {
        case .regular(let size):
            return .custom("NanumSquareRoundOTFR", size: size)
        case .bold(let size):
            return .custom("NanumSquareRoundOTFB", size: size)
        case .light(let size):
            return .custom("NanumSquareRoundOTFL", size: size)
        }
    }
}
