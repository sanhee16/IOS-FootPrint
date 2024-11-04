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
        self.categoryRepository.addCategory(nil, name: "기본", color: CategoryColor.black.rawValue, icon: CategoryIcon.emojiFace.rawValue)
        self.categoryRepository.addCategory(nil, name: "데이트", color: CategoryColor.pink.rawValue, icon: CategoryIcon.heart.rawValue)
        self.categoryRepository.addCategory(nil, name: "맛집", color: CategoryColor.orange.rawValue, icon: CategoryIcon.forkSpoon.rawValue)
        self.categoryRepository.addCategory(nil, name: "일상", color: CategoryColor.yellow.rawValue, icon: CategoryIcon.chatSmiley.rawValue)
        self.categoryRepository.addCategory(nil, name: "여행", color: CategoryColor.green.rawValue, icon: CategoryIcon.airport.rawValue)
        self.categoryRepository.addCategory(nil, name: "운동", color: CategoryColor.blue.rawValue, icon: CategoryIcon.groupRunning.rawValue)
        self.categoryRepository.addCategory(nil, name: "취미", color: CategoryColor.purple.rawValue, icon: CategoryIcon.brush.rawValue)
    }
}
