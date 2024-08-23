//
//  SaveDefaultCategoriesUseCase.swift
//  Footprint
//
//  Created by sandy on 8/23/24.
//

import Foundation
import SwiftUI

class SaveDefaultCategoriesUseCase {
    let categoryRepository: CategoryRepository
    let DEFAULT_COLORS: [String] = [
        Color.etc_black_high.toHex(),
        Color.etc_pink_high.toHex(),
        Color.etc_orange_high.toHex(),
        Color.etc_yellow_high.toHex(),
        Color.etc_green_high.toHex(),
        Color.etc_blue_high.toHex(),
        Color.etc_purple_high.toHex()
    ].compactMap({$0})
    
    let DEFAULT_ICONS_NAMES: [(String, String)] = [
        ("happy-face--smiley-chat-message-smile-emoji-face-satisfied", "Happy"),
        ("sad-face--smiley-chat-message-emoji-sad-face-unsatisfied", "Upset"),
        ("smiley-angry", "Angry"),
        ("smiley-cool", "Cool")
    ]
    
    
    init(categoryRepository: CategoryRepository) {
        self.categoryRepository = categoryRepository
    }
    
    func execute() {
        for color in DEFAULT_COLORS {
            for (icon, name) in DEFAULT_ICONS_NAMES {
                self.categoryRepository.addCategory(
                    CategoryV2(name: name, color: color, icon: icon)
                )
            }
        }
    }
}
