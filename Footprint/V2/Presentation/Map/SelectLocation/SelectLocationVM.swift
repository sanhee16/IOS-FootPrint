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
    
    //MARK: temporary note
    func updateTempLocation(_ location: Location, address: String) {
        self.temporaryNoteService.updateLocation(address: address, location: location)
    }
    
    func clearTempNote() {
        self.temporaryNoteService.clear()
    }
    
}
