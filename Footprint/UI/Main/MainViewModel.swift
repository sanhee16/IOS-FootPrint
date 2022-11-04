//
//  MainViewModel.swift
//  Footprint
//
//  Created by Studio-SJ on 2022/10/05.
//


import Foundation
import Combine


class MainViewModel: BaseViewModel {
    private var api: Api = Api.instance
    
    override init(_ coordinator: AppCoordinator) {
        super.init(coordinator)
    }
    
    func onAppear() {
        
    }
    
    func onClickAddFootprint() {
        self.coordinator?.presentAddFootprintView()
    }
}
