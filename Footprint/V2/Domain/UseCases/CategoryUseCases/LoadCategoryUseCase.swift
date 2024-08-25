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
    
    func execute(_ id: String) -> CategoryV2? {
        return self.categoryRepository.loadCategory(id)
    }
}

