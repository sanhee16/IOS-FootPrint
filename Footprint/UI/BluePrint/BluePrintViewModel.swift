//
//  BluePrintViewModel.swift
//  Footprint
//
//  Created by sandy on 2022/10/10.
//


import Foundation
import Combine
import UIKit

class BluePrintViewModel: BaseViewModel {
    override init(_ coordinator: AppCoordinator) {
        super.init(coordinator)
        
    }
    
    func onAppear() {
        
    }
    
    func onClose() {
        self.dismiss()
    }
}
