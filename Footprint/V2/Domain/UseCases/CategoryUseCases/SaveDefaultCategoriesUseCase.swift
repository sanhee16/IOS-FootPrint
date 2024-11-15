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
        self.categoryRepository.addCategory(nil, name: "기본", color: CategoryColor.black.rawValue, icon: CategoryIcon.emotion_01_emojiFace.rawValue, isDeletable: false)
        self.categoryRepository.addCategory(nil, name: "데이트", color: CategoryColor.pink.rawValue, icon: CategoryIcon.emotion_14_heart.rawValue, isDeletable: true)
        self.categoryRepository.addCategory(nil, name: "맛집", color: CategoryColor.orange.rawValue, icon: CategoryIcon.daily_03_forkSpoon.rawValue, isDeletable: true)
        self.categoryRepository.addCategory(nil, name: "일상", color: CategoryColor.yellow.rawValue, icon: CategoryIcon.emotion_10_chatSmiley.rawValue, isDeletable: true)
        self.categoryRepository.addCategory(nil, name: "여행", color: CategoryColor.green.rawValue, icon: CategoryIcon.daily_14_airplane.rawValue, isDeletable: true)
        self.categoryRepository.addCategory(nil, name: "운동", color: CategoryColor.blue.rawValue, icon: CategoryIcon.activity_07_groupRunning.rawValue, isDeletable: true)
        self.categoryRepository.addCategory(nil, name: "취미", color: CategoryColor.purple.rawValue, icon: CategoryIcon.activity_01_brush.rawValue, isDeletable: true)
    }
}
