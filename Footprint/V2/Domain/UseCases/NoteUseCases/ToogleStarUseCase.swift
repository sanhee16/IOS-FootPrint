//
//  ToogleStarUseCase.swift
//  Footprint
//
//  Created by sandy on 11/4/24.
//

class ToogleStarUseCase {
    let noteRepository: NoteRepository
    
    init(
        noteRepository: NoteRepository
    ) {
        self.noteRepository = noteRepository
    }
    
    func execute(_ id: String) -> Bool {
        return self.noteRepository.toggleStar(id: id)
    }
}
