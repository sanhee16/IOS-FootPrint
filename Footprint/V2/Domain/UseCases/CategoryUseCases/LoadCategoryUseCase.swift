//
//  LoadCategoryUseCase.swift
//  Footprint
//
//  Created by sandy on 8/25/24.
//

import Foundation

class LoadCategoryUseCase {
    let categoryRepository: CategoryRepository
    
    init(categoryRepository: CategoryRepository) {
        self.categoryRepository = categoryRepository
    }
    
    func execute(_ id: String) -> CategoryEntity? {
        return self.categoryRepository.loadCategory(id)
    }
}

