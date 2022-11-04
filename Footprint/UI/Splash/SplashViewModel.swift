//
//  SplashViewModel.swift
//  Footprint
//
//  Created by Studio-SJ on 2022/10/05.
//


import Foundation
import Combine


class SplashViewModel: BaseViewModel {
    
    override init(_ coordinator: AppCoordinator) {
        super.init(coordinator)
    }
    
    func onAppear() {
        self.coordinator?.presentMain()
    }
}
