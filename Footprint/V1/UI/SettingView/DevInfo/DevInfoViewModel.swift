//
//  DevInfoViewModel.swift
//  Footprint
//
//  Created by Studio-SJ on 2022/12/08.
//


import Foundation
import Combine
import UIKit

class DevInfoViewModel: BaseViewModelV1 {
    @Published var git: String = "https://github.com/sanhee16"
    override init(_ coordinator: AppCoordinatorV1) {
        super.init(coordinator)
        
    }
    
    func onAppear() {
        
    }
    
    func onClickUrl() {
        if let url = URL(string: git) {
            UIApplication.shared.open(url, options: [:])
        }
    }
    
    func onClose() {
        self.dismiss()
    }
}

