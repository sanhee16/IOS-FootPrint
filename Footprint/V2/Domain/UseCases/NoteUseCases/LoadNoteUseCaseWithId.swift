//
//  LoadNoteUseCaseWithId.swift
//  Footprint
//
//  Created by sandy on 10/31/24.
//

import Foundation

class LoadNoteUseCaseWithId {
    let noteRepository: NoteRepository
    let categoryRepository: CategoryRepository
    let memberRepository: MemberRepository
    
    init(
        noteRepository: NoteRepository,
        categoryRepository: CategoryRepository,
        memberRepository: MemberRepository
    ) {
        self.noteRepository = noteRepository
        self.categoryRepository = categoryRepository
        self.memberRepository = memberRepository
    }
    
    func execute(_ id: String) -> NoteEntity? {
        guard let note = self.noteRepository.loadNote(id: id),
              let category = self.categoryRepository.loadCategory(note.categoryId) else {
            return nil
        }
        
        let members = self.memberRepository.loadMembers(note.memberIds)
        
        let result = NoteEntity(
            id: note.id,
            title: note.title,
            content: note.content,
            createdAt: note.createdAt,
            imageUrls: note.imageUrls,
            isStar: note.isStar,
            latitude: note.latitude,
            longitude: note.longitude,
            address: note.address,
            category: category,
            members: self.memberRepository.loadMembers(note.memberIds)
        )
        
        return result
    }
}

