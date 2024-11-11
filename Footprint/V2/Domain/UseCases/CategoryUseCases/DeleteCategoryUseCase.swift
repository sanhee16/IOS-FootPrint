//
//  DeleteCategoryUseCase.swift
//  Footprint
//
//  Created by sandy on 8/23/24.
//

import Foundation

class DeleteCategoryUseCase {
    let categoryRepository: CategoryRepository
    let noteRepository: NoteRepository
    
    init(categoryRepository: CategoryRepository, noteRepository: NoteRepository) {
        self.categoryRepository = categoryRepository
        self.noteRepository = noteRepository
    }
    
    func execute(_ id: String) -> Bool {
        guard let item = self.categoryRepository.loadCategory(id), item.isDeletable else { return false }
        
        // 카테고리를 가지고 있는 모든 note 삭제
        let notes = self.noteRepository.loadNotes().filter({ $0.categoryId == id })
        notes.forEach { note in
            self.noteRepository.deleteNote(note.id)
        }
        
        // 카테고리 삭제
        return self.categoryRepository.deleteCategory(id)
    }
}
