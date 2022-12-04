//
//  Topbar.swift
//  Footprint
//
//  Created by Studio-SJ on 2022/10/06.
//


import SwiftUI

enum TopbarType: String {
    case back = "back"
    case close = "close"
    case closeWhite = "close_white"
    case none = ""
}

struct Topbar: View {
    var title: String
    var type: TopbarType
    var callback: (() -> Void)?
    
    init(_ title: String = "", type: TopbarType = .none, onTap: (() -> Void)? = nil) {
        self.title = title
        self.type = type
        self.callback = onTap
    }
    
    var body: some View {
        ZStack(alignment: .center) {
            HStack(alignment: .center, spacing: 0) {
                if type != .none {
                    Image(type.rawValue)
                        .resizable()
                        .scaledToFit()
                        .frame(both: 16)
                        .padding(.leading, 10)
                        .onTapGesture {
                            callback?()
                        }
                }
                Spacer()
            }
            Text(title)
                .font(.kr16b)
                .foregroundColor(Color.gray90)
        }
        .frame(height: 50, alignment: .center)
    }
}
