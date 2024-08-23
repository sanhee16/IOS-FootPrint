//
//  SplashVM2.swift
//  Footprint
//
//  Created by sandy on 8/8/24.
//

import Foundation
import CoreLocation
import GoogleMaps
import Factory

class SplashVM2: BaseViewModel {
    @Injected(\.userDefaultsManager) var userDefaultsManager
    @Injected(\.saveDefaultCategoriesUseCase) var saveDefaultCategoriesUseCase
    @Injected(\.loadCategoriesUseCase) var loadCategoriesUseCase
    
    @Published var isShowMain: Bool = false
    var myLocation: Location? = nil
    
    override init() {
        super.init()
    
        Task {
            await self.moveToMain()
        }
    }

    @MainActor
    private func moveToMain() {
        self.createDB()
        self.isShowMain = true
    }
    
    private func createDB() {
        if userDefaultsManager.launchBefore {
            return
        }
        self.saveDefaultCategoriesUseCase.execute()   
    }
    
}
