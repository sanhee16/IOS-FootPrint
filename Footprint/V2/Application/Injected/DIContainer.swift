//
//  DIContainer.swift
//  Footprint
//
//  Created by sandy on 8/22/24.
//

import Foundation
import Factory


//MARK: Repository
extension Container {
    var noteRepository: Factory<NoteRepository> {
        Factory(self) { RealNoteRepository() }
    }
}

//MARK: UseCase
extension Container {
    var saveNoteUseCase: Factory<SaveNoteUseCase> {
        Factory(self) { SaveNoteUseCase(noteRepository: self.noteRepository()) }
    }
}
