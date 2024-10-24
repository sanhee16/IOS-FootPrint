//
//  SaveCategoryUseCase.swift
//  Footprint
//
//  Created by sandy on 8/23/24.
//

import Foundation

class SaveCategoryUseCase {
    let categoryRepository: CategoryRepository
    
    init(categoryRepository: CategoryRepository) {
        self.categoryRepository = categoryRepository
    }
    
    func execute(_ id: String? = nil, name: String, color: CategoryColor, icon: CategoryIcon) {
        self.categoryRepository.addCategory(id, name: name, color: color.rawValue, icon: icon.rawValue)
    }
}
