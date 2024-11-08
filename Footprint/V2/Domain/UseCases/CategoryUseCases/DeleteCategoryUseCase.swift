//
//  DeleteCategoryUseCase.swift
//  Footprint
//
//  Created by sandy on 8/23/24.
//

import Foundation

class DeleteCategoryUseCase {
    let categoryRepository: CategoryRepository
    
    init(categoryRepository: CategoryRepository) {
        self.categoryRepository = categoryRepository
    }
    
    func execute(_ id: String) -> Bool {
        guard let item = self.categoryRepository.loadCategory(id), item.isDeletable else { return false }
        return self.categoryRepository.deleteCategory(id)
    }
}
