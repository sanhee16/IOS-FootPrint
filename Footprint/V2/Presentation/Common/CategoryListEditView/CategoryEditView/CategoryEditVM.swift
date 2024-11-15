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
        .emotion_01_emojiFace,
        .emotion_02_emojiSad,
        .emotion_03_emojiCheerful,
        .emotion_04_emojiLol,
        .emotion_05_emojiExcited,
        .emotion_06_emojiHungry,
        .emotion_07_emojiDevastated,
        .emotion_08_alien,
        .emotion_09_skull,
        .emotion_10_chatSmiley,
        .emotion_11_handOk,
        .emotion_12_thumbsUp,
        .emotion_13_star,
        .emotion_14_heart,
        .emotion_15_heartBreak,
        .emotion_16_chatSquare_warning,
        .emotion_17_chatSquare_question,
        .emotion_18_magicWand,
        .emotion_19_twinkle
    ]
    
    let dailyIcons: [CategoryIcon] = [
        .daily_01_coffee_mug,
        .daily_02_wine,
        .daily_03_forkSpoon,
        .daily_04_chicken,
        .daily_05_burger,
        .daily_06_donut,
        .daily_07_strawberry,
        .daily_08_waterMelon,
        .daily_09_carrot,
        .daily_10_smoking,
        .daily_11_bicycle,
        .daily_12_car,
        .daily_13_bus,
        .daily_14_airplane,
        .daily_15_baggage,
        .daily_16_beach,
        .daily_17_medicalBandage,
        .daily_18_money,
        .daily_19_money_piggy,
        .daily_20_shoppingCart,
        .daily_21_shoppingBasket,
        .daily_22_gift,
        .daily_23_home,
        .daily_24_location_pin,
        .daily_25_location_user
    ]
    
    let activityIcons: [CategoryIcon] = [
        .activity_01_brush,
        .activity_02_robot,
        .activity_03_controller_wireless,
        .activity_04_camera,
        .activity_05_mike,
        .activity_06_camera_video,
        .activity_07_groupRunning,
        .activity_08_yoga,
        .activity_09_fitnessBicycle,
        .activity_10_golfHole,
        .activity_11_baseball_batBall,
        .activity_12_bowlingSet,
        .activity_13_tambourine,
        .activity_14_headphones
    ]
    
    let natureIcons: [CategoryIcon] = [
        .nature_01_cat,
        .nature_02_dog,
        .nature_03_petPaw,
        .nature_04_tree,
        .nature_05_quill,
        .nature_06_sun,
        .nature_07_cloud,
        .nature_08_lightning,
        .nature_09_umbrella,
        .nature_10_snow,
        .nature_11_fire
    ]
    
    let etcIcons: [CategoryIcon] = [
        .etc_01_bookmark,
        .etc_02_cursorArrow1,
        .etc_03_cursorArrow2,
        .etc_04_bell,
        .etc_05_megaPhone,
        .etc_06_loading,
        .etc_07_phone,
        .etc_08_twoBubbles,
        .etc_09_letter,
        .etc_10_check,
        .etc_11_lightBulb,
        .etc_12_moustache,
        .etc_13_lock
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
