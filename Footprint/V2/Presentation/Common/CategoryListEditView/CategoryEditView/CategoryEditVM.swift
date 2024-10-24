//
//  CategoryEditVM.swift
//  Footprint
//
//  Created by sandy on 8/23/24.
//

import Foundation
import Factory
import SwiftUI

enum CategoryEditType {
    case create
    case modify
    
    var title: String {
        switch self {
        case .create:
            return "카테고리 추가하기"
        case .modify:
            return "카테고리 편집하기"
        }
    }
}

class CategoryEditVM: BaseViewModel {
    @Injected(\.saveNoteUseCase) var saveNoteUseCase
    @Injected(\.loadCategoriesUseCase) var loadCategoriesUseCase
    @Injected(\.saveCategoryUseCase) var saveCategoryUseCase
    var type: CategoryEditType
    
    private var categoryId: String? = nil
    @Published var name: String = "" { didSet { checkIsAvailableToSave() }}
    @Published var color: CategoryColor = .black { didSet { checkIsAvailableToSave() }}
    @Published var icon: CategoryIcon = .smile { didSet { checkIsAvailableToSave() }}
    @Published var isAvailableToSave: Bool = false
    let CHUNK_SIZE = 8
    
    let DEFAULT_COLORS: [CategoryColor] = [
        .black, .pink, .orange, .yellow, .green, .blue, .purple
    ]
    
    let DEFAULT_ICONS: [CategoryIcon] = [
        .athleticsRunning,
        .feet,
        .beer,
        .smile,
        .sad
    ]
    
    @Published var iconsRows: [[CategoryIcon]] = [[]]
    private var isLoading: Bool = false
    override init() {
        self.type = .create
        super.init()
        
        iconsRows = stride(from: 0, to: DEFAULT_ICONS.count, by: CHUNK_SIZE).map {
            Array(DEFAULT_ICONS[$0..<min($0 + CHUNK_SIZE, DEFAULT_ICONS.count)])
        }
    }
    
    func setCategory(_ categoryEntity: CategoryEntity?) {
        self.type = categoryEntity == nil ? .create : .modify
        self.categoryId = categoryEntity?.id
        self.name = categoryEntity?.name ?? ""
        self.color = categoryEntity?.color ?? DEFAULT_COLORS.first!
        self.icon = categoryEntity?.icon ?? DEFAULT_ICONS.first!
    }
    
    func saveCategory(_ onFinish: @escaping () -> ()) {
        if !self.isAvailableToSave { return }
        if self.isLoading { return }
        
        self.isLoading = true
        self.saveCategoryUseCase.execute(
            categoryId,
            name: self.name,
            color: self.color,
            icon: self.icon
        )
        self.isLoading = false
        onFinish()
    }
    
    private func checkIsAvailableToSave() {
        self.isAvailableToSave = false
        if self.name.isEmpty { return }
        self.isAvailableToSave = true
    }
}
