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
}

struct MenuText: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.kr12r)
            .foregroundColor(.gray90)
    }
}

