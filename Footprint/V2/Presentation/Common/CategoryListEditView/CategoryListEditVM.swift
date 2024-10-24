//
//  CategoryListEditVM.swift
//  Footprint
//
//  Created by sandy on 8/23/24.
//

import Foundation
import Factory

class CategoryListEditVM: BaseViewModel {
    @Injected(\.saveNoteUseCase) var saveNoteUseCase
    @Injected(\.loadCategoriesUseCase) var loadCategoriesUseCase
    @Published var categories: [CategoryEntity] = []
    
    override init() {
        super.init()
    }
    
    func loadCategories() {
        self.categories = loadCategoriesUseCase.execute()
    }
}
