//
//  SwiftUIViewModifier.swift
//  Footprint
//
//  Created by Studio-SJ on 2023/03/20.
//

import Foundation
import SwiftUI

extension View {
    func menuText() -> some View {
        modifier(MenuText())
    }
    
    func menuView(_ height: CGFloat = 50.0) -> some View {
        modifier(MenuView(height: height))
    }
}

struct MenuText: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.kr12r)
            .foregroundColor(.gray90)
    }
}

struct MenuView: ViewModifier {
    let height: CGFloat
    func body(content: Content) -> some View {
        content
            .padding([.leading, .trailing], 12)
            .frame(width: UIScreen.main.bounds.width - 24, height: 50, alignment: .center)
    }
}
