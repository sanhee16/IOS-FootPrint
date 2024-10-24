//
//  Topbar.swift
//  Footprint
//
//  Created by Studio-SJ on 2022/10/06.
//

import SwiftUI
import SDSwiftUIPack
import UIKit

enum TopbarType: String {
    case back = "ic_arrow_left"
    case close = "close"
    case closeWhite = "close_white"
    case none = ""
}

struct Topbar: View {
    var title: String
    var type: TopbarType
    var textColor: Color
    var callback: (() -> Void)?
    
    init(_ title: String = "", type: TopbarType = .none, textColor: Color = Color.gray90, onTap: (() -> Void)? = nil) {
        self.title = title
        self.type = type
        self.callback = onTap
        self.textColor = textColor
    }
    
    var body: some View {
        ZStack(alignment: .center) {
            HStack(alignment: .center, spacing: 0) {
                if type != .none {
                    Image(type.rawValue)
                        .resizable()
                        .scaledToFit()
                        .frame(both: 24)
                        .padding(.leading, 10)
                        .onTapGesture {
                            callback?()
                        }
                }
                Spacer()
            }
            Text(title)
                .font(.kr16b)
                .foregroundColor(textColor)
        }
        .frame(height: 55, alignment: .center)
        .background(Color(hex: "#F1F5F9"))
    }
}
