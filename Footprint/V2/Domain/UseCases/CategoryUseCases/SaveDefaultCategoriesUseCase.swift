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
    let DEFAULT_COLORS: [CategoryColor] = [
        .black, .pink, .orange, .yellow, .green, .blue, .purple
    ].compactMap({$0})
    
    let DEFAULT_ICONS_NAMES: [CategoryIcon] = [
        .athleticsRunning,
        .feet,
        .beer,
        .smile,
        .sad
    ]
    
    
    init(categoryRepository: CategoryRepository) {
        self.categoryRepository = categoryRepository
    }
    
    func execute() {
        self.categoryRepository.addCategory(nil, name: "맥주", color: CategoryColor.yellow.rawValue, icon: CategoryIcon.beer.rawValue)
        self.categoryRepository.addCategory(nil, name: "디저트", color: CategoryColor.orange.rawValue, icon: CategoryIcon.donut.rawValue)
        self.categoryRepository.addCategory(nil, name: "학원", color: CategoryColor.black.rawValue, icon: CategoryIcon.education.rawValue)
        self.categoryRepository.addCategory(nil, name: "맛집", color: CategoryColor.green.rawValue, icon: CategoryIcon.forkSpoon.rawValue)
        self.categoryRepository.addCategory(nil, name: "카페", color: CategoryColor.blue.rawValue, icon: CategoryIcon.coffee.rawValue)
        self.categoryRepository.addCategory(nil, name: "놀거리", color: CategoryColor.purple.rawValue, icon: CategoryIcon.planet.rawValue)
    }
}
