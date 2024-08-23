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
    
    func execute(_ category: CategoryV2) {
        
    }
}
