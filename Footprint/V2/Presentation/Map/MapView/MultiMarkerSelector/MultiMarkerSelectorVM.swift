//
//  MultiMarkerSelectorVM.swift
//  Footprint
//
//  Created by sandy on 11/20/24.
//

import Foundation
import Factory

class MultiMarkerSelectorVM: ObservableObject {
    @Injected(\.loadNoteUseCaseWithAddress) var loadNoteUseCaseWithAddress
    
    
    @Published var notes: [Note] = []
    @Published var address: String = ""
    @Published var location: Location?
    @Published var totalNotes: Int = 0
    
    init(address: String) {
        self.notes = []
        self.address = address
        self.location = nil
        
        self.loadData()
    }
    
    private func loadData() {
        self.notes = self.loadNoteUseCaseWithAddress.execute(self.address)
        self.totalNotes = self.notes.count
        self.notes = Array(self.notes.prefix(3))
        
        if let item = self.notes.first {
            self.location = Location(latitude: item.latitude, longitude: item.longitude)
        }
    }
    
}
