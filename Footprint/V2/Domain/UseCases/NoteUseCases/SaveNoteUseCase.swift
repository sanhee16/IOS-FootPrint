//
//  SaveNoteUseCase.swift
//  Footprint
//
//  Created by sandy on 8/22/24.
//

import Foundation

class SaveNoteUseCase {
    let noteRepository: NoteRepository
    
    init(noteRepository: NoteRepository) {
        self.noteRepository = noteRepository
    }
    
    func execute(_ data: Note) {
        self.noteRepository.saveNotes(data)
    }
}
