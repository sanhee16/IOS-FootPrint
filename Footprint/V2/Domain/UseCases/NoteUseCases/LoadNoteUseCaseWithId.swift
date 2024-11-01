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
    
    func execute(_ id: String) -> Note? {
        guard var note = self.noteRepository.loadNote(id), let category = self.categoryRepository.loadCategory(note.categoryId) else { return nil }
        let peopleWith = self.memberRepository.loadMembers(note.peopleWithIds)
        note.category = category
        note.peopleWith = peopleWith
        return note
    }
}

