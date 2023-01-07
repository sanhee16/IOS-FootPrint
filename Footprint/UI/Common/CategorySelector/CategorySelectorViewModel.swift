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

typealias CategoryTag = Int

class CategorySelectorViewModel: BaseViewModel {
    @Published var categoryList: [Category] = []
    @Published var selectedCategory: Category? = nil
    @Published var categoryCnt: [CategoryTag: Int] = [:]
    let type: CategorySelectorType
    private let realm: Realm
    
    
    init(_ coordinator: AppCoordinator, type: CategorySelectorType) {
        self.realm = try! Realm()
        self.type = type
        if case let .select(selectedCategory, _) = type {
            self.selectedCategory = selectedCategory
        }
        super.init(coordinator)
        
        self.objectWillChange.send()
    }
    
    func onAppear() {
        loadCategory()
        loadCategoryCnt()
    }
    
    func onClose() {
        if case let .select(selectedCategory, callback) = type {
            self.dismiss(animated: false) {
                callback(selectedCategory)
            }
        } else if case .edit = type {
            self.dismiss()
        }
    }
    
    func onFinishSelect() {
        if case let .select(_, callback) = type {
            self.dismiss(animated: false) {[weak self] in
                guard let self = self, let selectedCategory = self.selectedCategory else { return }
                callback(selectedCategory)
            }
        } else if case .edit = type {
            self.dismiss()
        }
    }
    
    func onClickAddCategory() {
        self.coordinator?.presentAddCategoryView(type: AddCategoryType(type: .create), onDismiss: {[weak self] in
            self?.loadCategory()
        })
    }
    
    func selectCategory(_ item: Category) {
        if case .select(_, _) = type {
            self.selectedCategory = item
        } else if case .edit = type {
            if item.tag == 0 {
                self.alert(.ok, title: "기본 카테고리는 편집할 수 없습니다.")
                return
            }
            self.coordinator?.presentAddCategoryView(type: AddCategoryType(type: .update, category: item), onEraseCategory: { [weak self] in
                self?.loadCategory()
            }, onDismiss: { [weak self] in
                self?.loadCategory()
            })
        }
    }
    
    private func loadCategory() {
        self.categoryList = Array(self.realm.objects(Category.self))
    }
    
    private func loadCategoryCnt() {
        if case .edit = type {
            let footprints = self.realm.objects(FootPrint.self)
            for i in footprints {
                let category = i.tag.getCategory()
                if let tag = category?.tag {
                    self.categoryCnt[tag] = (self.categoryCnt[tag] ?? 0) + 1
                }
            }
        }
        print("categoryCnt: \(self.categoryCnt)")
    }
    
    func isSelectedCategory(_ item: Category) -> Bool {
        return item == self.selectedCategory
    }
    
//    func getCategoryCnt(_ item: Category) -> Int {
//
//    }
}
