//
//  LoadFootprintsUseCase.swift
//  Footprint
//
//  Created by sandy on 11/14/24.
//

class LoadFootprintsUseCase {
    let noteRepository: NoteRepository
    
    init(noteRepository: NoteRepository) {
        self.noteRepository = noteRepository
    }
    
    func execute() -> [TripFootprintEntity] {
        return self.noteRepository.loadNotes().map({
            TripFootprintEntity(id: $0.id, title: $0.title, content: $0.content, address: $0.address)
        })
    }
}
