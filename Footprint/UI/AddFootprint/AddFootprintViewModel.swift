//
//  AddFootprintViewModel.swift
//  Footprint
//
//  Created by Studio-SJ on 2022/11/04.
//

import Foundation
import Combine
import UIKit

class AddFootprintViewModel: BaseViewModel {
    
    @Published var title: String = ""
    @Published var content: String = ""
    @Published var images: [UIImage] = []
    
    override init(_ coordinator: AppCoordinator) {
        super.init(coordinator)
    }
    
    func onAppear() {
        
    }
    
    func onClose() {
        self.dismiss()
    }
    
    
}
