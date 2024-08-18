//
//  TabBarService.swift
//  Footprint
//
//  Created by sandy on 8/18/24.
//

import Foundation

class TabBarService: ObservableObject {
    @Published var isShowTabBar: Bool = true
    
    init() {
        
    }
    
    func toggleTabBar() {
        self.isShowTabBar.toggle()
    }
}

