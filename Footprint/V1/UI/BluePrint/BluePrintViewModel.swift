//
//  BluePrintViewModel.swift
//  Footprint
//
//  Created by sandy on 2022/10/10.
//


import Foundation
import Combine
import UIKit

class BluePrintViewModel: BaseViewModelV1 {
    override init(_ coordinator: AppCoordinatorV1) {
        super.init(coordinator)
        
    }
    
    func onAppear() {
        
    }
    
    func onClose() {
        self.dismiss()
    }
}
