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
    @Injected(\.updateCategoryUseCase) var updateCategoryUseCase
    @Injected(\.saveCategoryUseCase) var saveCategoryUseCase
    var type: CategoryEditType
    
    private var categoryId: String? = nil
    @Published var name: String = "" { didSet { checkIsAvailableToSave() }}
    @Published var color: CategoryColor? = nil { didSet { checkIsAvailableToSave() }}
    @Published var icon: CategoryIcon? = nil { didSet { checkIsAvailableToSave() }}
    @Published var isAvailableToSave: Bool = false
    var idx: Int? = nil
    let CHUNK_SIZE = 8
    
    let DEFAULT_COLORS: [CategoryColor] = [
        .black, .pink, .orange, .yellow, .green, .blue, .purple
    ]
    
    let emotionIcons: [CategoryIcon] = [
        .alien, .chatSmiley, .chatSquare_question, .chatSquare_warning, .emojiCheerful, .emojiDevastated, .emojiExcited, .emojiFace, .emojiHungry, .emojiLol, .emojiSad, .handOk, .heart, .heartBreak, .magicWand, .skull, .star, .thumbsUp, .twinkle
    ]
    let dailyIcons: [CategoryIcon] = [
        .airport, .baggage, .beach, .bicycle, .burger, .bus, .car, .carrot, .chicken, .coffee_mug, .donut, .forkSpoon, .gift, .home, .location_pin, .location_user, .medicalBandage, .money_piggy, .money, .shoppingBasket, .shoppingCart, .smoking, .strawberry, .waterMelon, .wine
    ]
    let activityIcons: [CategoryIcon] = [
        .baseball_batBall, .bowlingSet, .brush, .camera_video, .camera, .controller_wireless, .fitnessBicycle, .golfHole, .groupRunning, .headphones, .mike, .robot, .tambourine, .yoga
    ]
    let natureIcons: [CategoryIcon] = [
        .cat, .cloud, .dog, .fire, .lightning, .petPaw, .quill, .snow, .sun, .tree, .umbrella
    ]
    let etcIcons: [CategoryIcon] = [
        .bell, .bookmark, .calendar_check, .chat_twoBubbles, .cursorArrow1, .cursorArrow2, .letter, .lightBulb, .loading, .lock, .megaPhone, .moustache, .phone
    ]
    
    
    @Published var iconsRows: [[CategoryIcon]] = [[]]
    private var isLoading: Bool = false
    override init() {
        self.type = .create
        super.init()
    }
    
    func setCategory(_ categoryEntity: CategoryEntity?) {
        self.type = categoryEntity == nil ? .create : .modify
        self.categoryId = categoryEntity?.id
        self.idx = categoryEntity?.idx
        self.name = categoryEntity?.name ?? ""
        self.color = categoryEntity?.color ?? DEFAULT_COLORS.first!
        self.icon = categoryEntity?.icon ?? emotionIcons.first!
    }
    
    func saveCategory(_ onFinish: @escaping () -> ()) {
        if !self.isAvailableToSave { return }
        guard let color = self.color, let icon = self.icon else {
             return
        }
        
        if self.isLoading { return }
        
        self.isLoading = true
        
        switch type {
        case .create:
            self.saveCategoryUseCase.execute(
                categoryId,
                name: self.name,
                color: color,
                icon: icon,
                isDeletable: true
            )
        case .modify:
            guard let categoryId = self.categoryId, let idx = self.idx else { return }
            self.updateCategoryUseCase.execute(
                categoryId,
                idx: idx,
                name: self.name,
                color: color,
                icon: icon,
                isDeletable: true
            )
        }
        self.isLoading = false
        onFinish()
    }
    
    private func checkIsAvailableToSave() {
        self.isAvailableToSave = false
        if self.name.isEmpty { return }
        self.isAvailableToSave = true
    }
}
