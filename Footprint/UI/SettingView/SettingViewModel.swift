//
//  SettingViewModel.swift
//  Footprint
//
//  Created by sandy on 2022/12/05.
//



import Foundation
import Combine
import UIKit

class SettingViewModel: BaseViewModel {
    override init(_ coordinator: AppCoordinator) {
        super.init(coordinator)
        
    }
    
    func onAppear() {
        
    }
    
    func onClose() {
        self.dismiss()
    }
}
