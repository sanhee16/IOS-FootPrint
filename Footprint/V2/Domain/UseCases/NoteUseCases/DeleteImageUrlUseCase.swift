//
//  DeleteImageUrlUseCase.swift
//  Footprint
//
//  Created by sandy on 11/4/24.
//

class DeleteImageUrlUseCase {
    let noteRepository: NoteRepository
    
    init(noteRepository: NoteRepository) {
        self.noteRepository = noteRepository
    }
    
    func execute(_ id: String, url: String) {
        self.noteRepository.deleteImageUrl(id, url: url)
    }
}
