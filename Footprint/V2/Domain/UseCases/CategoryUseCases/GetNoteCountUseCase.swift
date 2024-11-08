//
//  GetNoteCountUseCase.swift
//  Footprint
//
//  Created by sandy on 11/8/24.
//

class GetNoteCountUseCase {
    let noteRepository: NoteRepository
    
    init(
        noteRepository: NoteRepository
    ) {
        self.noteRepository = noteRepository
    }
    
    func execute(_ id: String) -> Int {
        return self.noteRepository.loadNotes().filter({ $0.categoryId == id }).count
    }
}
