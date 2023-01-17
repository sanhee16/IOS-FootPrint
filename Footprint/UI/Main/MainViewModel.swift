//
//  MainViewModel.swift
//  Footprint
//
//  Created by Studio-SJ on 2022/10/05.
//

import Foundation
import Combine

class MainViewModel: BaseViewModel {
    @Published var currentTab: MainMenuType = .map
    
    override init(_ coordinator: AppCoordinator) {
        super.init(coordinator)
    }
    
    func onAppear() {
        
    }
    
    func viewDidLoad() {
        
    }
    
    func onClickTab(_ tab: MainMenuType) {
        self.currentTab = tab
    }
}
