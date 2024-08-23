//
//  LoadCategoriesUseCase.swift
//  Footprint
//
//  Created by sandy on 8/23/24.
//

import Foundation

class LoadCategoriesUseCase {
    let categoryRepository: CategoryRepository
    
    init(categoryRepository: CategoryRepository) {
        self.categoryRepository = categoryRepository
    }
    
    func execute() -> [CategoryV2] {
        return self.categoryRepository.loadCategories()
    }
}
