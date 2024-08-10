//
//  SwiftUIViewModifier.swift
//  Footprint
//
//  Created by Studio-SJ on 2023/03/20.
//

import Foundation
import SwiftUI
import SDSwiftUIPack

extension View {
    func menuText() -> some View {
        modifier(MenuText())
    }
    
    func menuView(_ height: CGFloat? = 50.0) -> some View {
        modifier(MenuView(height: height))
    }
    
    func addItemBackground(_ cornerRadius: CGFloat = 12.0) -> some View {
        modifier(AddItemBackground(cornerRadius: cornerRadius))
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
    let height: CGFloat?
    let padding: CGFloat = 6.0
    func body(content: Content) -> some View {
        content
            .padding([.leading, .trailing], padding)
            .frame(width: UIScreen.main.bounds.width - padding * 2, height: 50, alignment: .center)
    }
}


struct AddItemBackground: ViewModifier {
    let cornerRadius: CGFloat
    func body(content: Content) -> some View {
        content
            .contentShape(Rectangle())
            .background(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .foregroundColor(.textColor3)
            )
    }
}
