//
//  DeleteNoteUseCase.swift
//  Footprint
//
//  Created by sandy on 12/23/24.
//

class DeleteNoteUseCase {
    private let noteRepository: NoteRepository
    
    init(noteRepository: NoteRepository) {
        self.noteRepository = noteRepository
    }
    
    func execute(_ id: String) -> String? {
        self.noteRepository.deleteNote(id)
    }
}

