//
//  CategorySelectorViewModel.swift
//  Footprint
//
//  Created by sandy on 2023/01/07.
//

import Foundation
import Combine
import UIKit
import RealmSwift

class CategorySelectorViewModel: BaseViewModel {
    @Published var categoryList: [Category] = []
    @Published var selectedCategory: Category
    private let originalCategory: Category
    private let realm: Realm
    private let callback: (Category)->()
    
    init(_ coordinator: AppCoordinator, selectedCategory: Category, callback: @escaping (Category)->()) {
        self.realm = try! Realm()
        self.selectedCategory = selectedCategory
        self.originalCategory = selectedCategory
        self.callback = callback
        super.init(coordinator)
    }
    
    func onAppear() {
        loadCategory()
    }
    
    func onClose() {
        self.dismiss(animated: false) {[weak self] in
            guard let self = self else { return }
            self.callback(self.originalCategory)
        }
    }
    
    func onFinishSelect() {
        self.dismiss(animated: false) {[weak self] in
            guard let self = self else { return }
            self.callback(self.selectedCategory)
        }
    }
    
    func onClickAddCategory() {
        self.coordinator?.presentAddCategoryView(type: AddCategoryType(type: .create), onDismiss: {[weak self] in
            self?.loadCategory()
        })
    }
    
    func selectCategory(_ item: Category) {
        self.selectedCategory = item
    }
    
    private func loadCategory() {
        self.categoryList = Array(self.realm.objects(Category.self))
    }
    
    func isSelectedCategory(_ item: Category) -> Bool {
        return item == self.selectedCategory
    }
}
