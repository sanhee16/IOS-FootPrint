//
//  TabBarService.swift
//  Footprint
//
//  Created by sandy on 8/18/24.
//

import Foundation

class TabBarService: ObservableObject {
    @Published var isShowTabBar: Bool = true
    @Published var currentTab: MainMenuType = .map
    
    init() {
        addObserver()
    }
    
    func onTab(_ tab: MainMenuType) {
        self.currentTab = tab
    }
    
    func setIsShowTabBar(_ isShow: Bool) {
        self.isShowTabBar = isShow
    }
    
    private func addObserver() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(
                didRecieveChangeMapStatusNotification(
                    _:
                )
            ),
            name: .isShowTabBar,
            object: nil
        )
    }

    @objc func didRecieveChangeMapStatusNotification(_ notification: Notification) {
        if let isShow = notification.object as? Bool {
            self.setIsShowTabBar(isShow)
        }
    }
}

