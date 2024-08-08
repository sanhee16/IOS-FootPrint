//
//  ShowImageViewModel.swift
//  Footprint
//
//  Created by sandy on 2022/12/04.
//


import Foundation
import Combine
import SwiftUIPager
import UIKit

class ShowImageViewModel: BaseViewModel {
    @Published var page: Page
    @Published var images: [UIImage]
    
    
    init(_ coordinator: AppCoordinator, imageIdx: Int, images: [UIImage]) {
        self.images = images
        self.page = .withIndex(imageIdx)
        super.init(coordinator)
    }
    
    func onAppear() {
        
    }
    
    func onClose() {
        self.dismiss()
    }
}

