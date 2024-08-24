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
    @Published var color: String = "" { didSet { checkIsAvailableToSave() }}
    @Published var icon: String = "" { didSet { checkIsAvailableToSave() }}
    @Published var isAvailableToSave: Bool = false
    let CHUNK_SIZE = 8
    
    let DEFAULT_COLORS: [String] = [
        Color.etc_black_high.toHex(),
        Color.etc_pink_high.toHex(),
        Color.etc_orange_high.toHex(),
        Color.etc_yellow_high.toHex(),
        Color.etc_green_high.toHex(),
        Color.etc_blue_high.toHex(),
        Color.etc_purple_high.toHex()
    ].compactMap({$0})
    @Published var iconsRows: [[String]] = [[]]
    private let DEFAULT_ICONS: [String] = [
        "happy-face--smiley-chat-message-smile-emoji-face-satisfied",
        "sad-face--smiley-chat-message-emoji-sad-face-unsatisfied",
        "smiley-angry",
        "smiley-cool",
        "sad-face--smiley-chat-message-emoji-sad-face-unsatisfied",
        "smiley-angry",
        "smiley-cool",
        "sad-face--smiley-chat-message-emoji-sad-face-unsatisfied",
        "smiley-angry",
        "smiley-cool",
        "sad-face--smiley-chat-message-emoji-sad-face-unsatisfied",
        "smiley-angry",
        "smiley-cool",
        "sad-face--smiley-chat-message-emoji-sad-face-unsatisfied",
        "smiley-angry",
        "smiley-cool",
        "sad-face--smiley-chat-message-emoji-sad-face-unsatisfied",
        "smiley-angry",
        "smiley-cool",
        "sad-face--smiley-chat-message-emoji-sad-face-unsatisfied",
        "smiley-angry",
        "smiley-cool",
        "sad-face--smiley-chat-message-emoji-sad-face-unsatisfied",
        "smiley-angry",
        "smiley-cool",
        "sad-face--smiley-chat-message-emoji-sad-face-unsatisfied",
        "smiley-angry",
        "smiley-cool",
        "sad-face--smiley-chat-message-emoji-sad-face-unsatisfied",
        "smiley-angry",
        "smiley-cool",
        "sad-face--smiley-chat-message-emoji-sad-face-unsatisfied",
        "smiley-angry",
        "smiley-cool"
    ]
    private var isLoading: Bool = false
    override init() {
        self.type = .create
        super.init()
        
        iconsRows = stride(from: 0, to: DEFAULT_ICONS.count, by: CHUNK_SIZE).map {
            Array(DEFAULT_ICONS[$0..<min($0 + CHUNK_SIZE, DEFAULT_ICONS.count)])
        }
    }
    
    func setCategory(_ categoryV2: CategoryV2?) {
        self.type = categoryV2 == nil ? .create : .modify
        self.categoryId = categoryV2?.id
        self.name = categoryV2?.name ?? ""
        self.color = categoryV2?.color ?? DEFAULT_COLORS.first ?? ""
        self.icon = categoryV2?.icon ?? DEFAULT_ICONS.first ?? ""
    }
    
    func saveCategory(_ onFinish: @escaping () -> ()) {
        if !self.isAvailableToSave { return }
        if self.isLoading { return }
        
        self.isLoading = true
        let category = CategoryV2(id: categoryId, name: self.name, color: self.color, icon: self.icon)

        self.saveCategoryUseCase.execute(category)
        self.isLoading = false
        onFinish()
    }
    
    private func checkIsAvailableToSave() {
        self.isAvailableToSave = false
        if self.name.isEmpty || self.color.isEmpty || self.icon.isEmpty { return }
        self.isAvailableToSave = true
    }
}
