//
//  LoadAllNoteUseCase.swift
//  Footprint
//
//  Created by sandy on 8/25/24.
//

import Foundation

class LoadAllNoteUseCase {
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
    
    func execute() -> [Note] {
        var list = self.noteRepository.loadNotes()
        for i in list.indices {
            if let category = self.categoryRepository.loadCategory(list[i].categoryId) {
                let peopleWith = self.memberRepository.loadMembers(list[i].peopleWithIds)
                list[i].category = category
                list[i].peopleWith = peopleWith
            }
        }

        return list
    }
}
