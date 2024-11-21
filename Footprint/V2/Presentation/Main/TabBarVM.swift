//
//  TabBarVM.swift
//  Footprint
//
//  Created by sandy on 8/18/24.
//

import Foundation

class TabBarVM: ObservableObject {
    @Published var isShowTabBar: Bool = true
    
    init() {
        addObserver()
    }
    
    func setIsShowTabBar(_ isShow: Bool) {
        print("setIsShowTabBar: \(isShow)")
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

