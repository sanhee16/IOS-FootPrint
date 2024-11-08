//
//  UpdateCategoryOrderUseCase.swift
//  Footprint
//
//  Created by sandy on 11/8/24.
//

class UpdateCategoryOrderUseCase {
    let categoryRepository: CategoryRepository
    
    init(categoryRepository: CategoryRepository) {
        self.categoryRepository = categoryRepository
    }
    
    func execute(_ categories: [CategoryEntity]) {
        self.categoryRepository.updateOrder(categories)
    }
}
