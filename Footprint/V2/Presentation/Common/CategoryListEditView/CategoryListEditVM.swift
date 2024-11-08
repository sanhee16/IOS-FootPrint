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
    @Injected(\.getNoteCountUseCase) var getNoteCountUseCase
    @Published var categories: [CategoryEntity] = [] {
        didSet {
            self.updateOrder()
        }
    }
    @Published var isLoading: Bool = false
    @Published var deleteCategory: CategoryEntity? = nil
    @Published var deleteCategoryNoteCount: Int = 0
    private var saveTimer: Timer?
    
    override init() {
        super.init()
    }
    
    func loadCategories() {
        self.categories = loadCategoriesUseCase.execute()
    }
    
    func getDeletedCategoryNoteCount(_ id: String) {
        self.deleteCategoryNoteCount = self.getNoteCountUseCase.execute(id)
    }

    func onDelete(_ id: String) {
        guard let category = deleteCategory else { return }
        let _ = self.deleteCategoryUseCase.execute(category.id)
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
