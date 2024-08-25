//
//  LoadNoteUseCase.swift
//  Footprint
//
//  Created by sandy on 8/25/24.
//

import Foundation

class LoadNoteUseCase {
    let noteRepository: NoteRepository
    
    init(noteRepository: NoteRepository) {
        self.noteRepository = noteRepository
    }
    
    func execute() -> [NoteData] {
        self.noteRepository.loadNotes()
    }
}
