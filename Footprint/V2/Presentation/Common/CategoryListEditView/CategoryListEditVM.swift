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
    @Injected(\.deleteCategoryUseCase) var deleteCategoryUseCase
    @Injected(\.updateCategoryOrderUseCase) var updateCategoryOrderUseCase
    @Published var categories: [CategoryEntity] = [] {
        didSet {
            self.updateOrder()
        }
    }
    @Published var isLoading: Bool = false
    private var saveTimer: Timer?
    
    override init() {
        super.init()
    }
    
    func loadCategories() {
        self.categories = loadCategoriesUseCase.execute()
    }

    func deleteCategory(_ id: String) {
        let _ = self.deleteCategoryUseCase.execute(id)
        self.loadCategories()
    }
    
    func updateOrder() {
        // 이전 타이머 취소
        saveTimer?.invalidate()
        
        // 0.7초후에 저장
        saveTimer = Timer.scheduledTimer(withTimeInterval: 0.7, repeats: false) { _ in
            self.updateCategoryOrderUseCase.execute(self.categories)
        }
    }
}
