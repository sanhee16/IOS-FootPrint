//
//  LoadNoteUseCaseWithAddress.swift
//  Footprint
//
//  Created by sandy on 11/1/24.
//

import Foundation

class LoadNoteUseCaseWithAddress {
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
    
    func execute(_ address: String, type: FootprintSortType) -> [Note] {
        var list = self.noteRepository.loadNote(address: address)
        
        switch type {
        case .latest:
            list = list.sorted(by: { lhs, rhs in
                lhs.createdAt > rhs.createdAt
            })
        case .earliest:
            list = list.sorted(by: { lhs, rhs in
                lhs.createdAt < rhs.createdAt
            })
        }
        
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
