//
//  TripDetailVM.swift
//  Footprint
//
//  Created by sandy on 11/15/24.
//

import Combine
import Factory
import Foundation
import SwiftUI

class TripDetailVM: ObservableObject {
    @Injected(\.loadTripUseCase) var loadTripUseCase
    
    var title: String = ""
    var content: String = ""
    var startAt: Date = Date()
    var endAt: Date = Date()
    var icon: TripIconEntity? = nil
    var footprints: [TripFootprintEntity] = []
    let id: String
    
    init(id: String) {
        self.id = id
    }
    
    func loadData() {
        if let result = self.loadTripUseCase.execute(id) {
            self.title = result.title
            self.content = result.content
            self.startAt = Date(timeIntervalSince1970: Double(result.startAt))
            self.endAt = Date(timeIntervalSince1970: Double(result.endAt))
            self.icon = result.icon
            self.footprints = result.footprints
            self.objectWillChange.send()
        } else {
            //TODO: fail to load
        }
    }
}
