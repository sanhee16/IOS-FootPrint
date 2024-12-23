//
//  FootprintListWtihSameAddressVM.swift
//  Footprint
//
//  Created by sandy on 12/23/24.
//

import Foundation
import Combine
import Factory


class FootprintListWtihSameAddressVM: ObservableObject {
    @Injected(\.loadNoteWithAddressUseCase) var loadNoteWithAddressUseCase
    @Injected(\.temporaryNoteService) var temporaryNoteService
    
    @Published var notes: [NoteEntity] = []
    var address: String
    
    
    init(address: String) {
        self.address = address
    }
    
    func loadData() {
        self.notes = self.loadNoteWithAddressUseCase.execute(address, type: .latest)
    }
    
    func clearTempNote() {
        self.temporaryNoteService.clear()
    }
}
