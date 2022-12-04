//
//  ShowImageViewModel.swift
//  Footprint
//
//  Created by sandy on 2022/12/04.
//


import Foundation
import Combine
import UIKit

class ShowImageViewModel: BaseViewModel {
    @Published var image: UIImage
    init(_ coordinator: AppCoordinator, image: UIImage) {
        self.image = image
        super.init(coordinator)
    }
    
    func onAppear() {
        
    }
    
    func onClose() {
        self.dismiss()
    }
}

