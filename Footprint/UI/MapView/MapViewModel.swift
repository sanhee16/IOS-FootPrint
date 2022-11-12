//
//  MapViewModel.swift
//  Footprint
//
//  Created by sandy on 2022/11/10.
//

import Foundation

class MapViewModel: BaseViewModel {
    @Published var location: Location
    
    init(_ coordinator: AppCoordinator, location: Location) {
        self.location = location
        super.init(coordinator)
    }
    
    func onAppear() {
        
    }
    
    func onClose() {
        self.dismiss()
    }
    
    func onTapMarker() {
        print("on tap marker")
        self.coordinator?.presentAddFootprintView(location: self.location)
    }
}
