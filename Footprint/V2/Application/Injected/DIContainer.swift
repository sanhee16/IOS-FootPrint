//
//  DIContainer.swift
//  Footprint
//
//  Created by sandy on 8/22/24.
//

import Foundation
import Factory

extension Container {
    var userDefaultsManager: Factory<Defaults> {
        Factory(self) { Defaults() }
    }
    
}

//MARK: Repository
extension Container {
    var noteRepository: Factory<NoteRepository> {
        Factory(self) { RealNoteRepository() }
    }
    
    var categoryRepository: Factory<CategoryRepository> {
        Factory(self) { RealCategoryRepository() }
    }
}

//MARK: UseCase
extension Container {
    var saveNoteUseCase: Factory<SaveNoteUseCase> {
        Factory(self) { SaveNoteUseCase(noteRepository: self.noteRepository()) }
    }
    
    var saveDefaultCategoriesUseCase: Factory<SaveDefaultCategoriesUseCase> {
        Factory(self) { SaveDefaultCategoriesUseCase(categoryRepository: self.categoryRepository()) }
    }
    
    var loadCategoriesUseCase: Factory<LoadCategoriesUseCase> {
        Factory(self) { LoadCategoriesUseCase(categoryRepository: self.categoryRepository()) }
    }
}
