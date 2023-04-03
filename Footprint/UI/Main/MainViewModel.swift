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
    @Published var isShowAds: Bool = false
    
    override init(_ coordinator: AppCoordinator) {
        self.isShowAds = Remote.init().isShowAds()
        super.init(coordinator)
    }
    
    func onAppear() {
        checkNetworkConnect()
    }
    
    func viewDidLoad() {
        
    }
    
    func onClickTab(_ tab: MainMenuType) {
        self.currentTab = tab
    }
}
