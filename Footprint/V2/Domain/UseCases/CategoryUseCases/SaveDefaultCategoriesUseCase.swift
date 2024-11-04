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
    
    init(categoryRepository: CategoryRepository) {
        self.categoryRepository = categoryRepository
    }
    
    func execute() {
        // basic icons
        self.categoryRepository.addCategory(nil, name: "lock", color: CategoryColor.black.rawValue, icon: CategoryIcon.lock.rawValue)
        self.categoryRepository.addCategory(nil, name: "car", color: CategoryColor.pink.rawValue, icon: CategoryIcon.car.rawValue)
        self.categoryRepository.addCategory(nil, name: "strawberry", color: CategoryColor.orange.rawValue, icon: CategoryIcon.strawberry.rawValue)
        self.categoryRepository.addCategory(nil, name: "handOk", color: CategoryColor.yellow.rawValue, icon: CategoryIcon.handOk.rawValue)
        self.categoryRepository.addCategory(nil, name: "tree", color: CategoryColor.green.rawValue, icon: CategoryIcon.tree.rawValue)
        self.categoryRepository.addCategory(nil, name: "thumbsUp", color: CategoryColor.blue.rawValue, icon: CategoryIcon.thumbsUp.rawValue)
        self.categoryRepository.addCategory(nil, name: "chatSquare_warning", color: CategoryColor.purple.rawValue, icon: CategoryIcon.chatSquare_warning.rawValue)
    }
}
