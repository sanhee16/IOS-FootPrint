//
//  UpdateCategoryUseCase.swift
//  Footprint
//
//  Created by sandy on 8/23/24.
//

import Foundation

class UpdateCategoryUseCase {
    let categoryRepository: CategoryRepository
    
    init(categoryRepository: CategoryRepository) {
        self.categoryRepository = categoryRepository
    }
    
    func execute(_ id: String, idx: Int, name: String, color: CategoryColor, icon: CategoryIcon, isDeletable: Bool) {
        self.categoryRepository.updateCategory(id, idx: idx, name: name, color: color.rawValue, icon: icon.rawValue, isDeletable: isDeletable)
    }
}
