//
//  SelectLocationVM.swift
//  Footprint
//
//  Created by sandy on 8/13/24.
//

import Combine
import Factory

class SelectLocationVM: BaseViewModel {
    @Injected(\.temporaryNoteService) var temporaryNoteService
    
    override init() {
        
    }
    
    func onAppear() {
        
    }
    
    //MARK: temporary note
    func updateTempLocation(_ location: Location, address: String) -> TemporaryNote? {
        self.temporaryNoteService.updateTempLocation(address: address, location: location)
    }
    
    func updateTempNote(_ id: String) {
        self.temporaryNoteService.updateTempNote(id)
    }
    
    func clearFootprint() {
        self.temporaryNoteService.clear()
    }
    
}
