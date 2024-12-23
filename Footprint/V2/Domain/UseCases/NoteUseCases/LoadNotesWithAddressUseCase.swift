//
//  loadNoteWithAddressUseCase.swift
//  Footprint
//
//  Created by sandy on 11/1/24.
//

import Foundation

class LoadNotesWithAddressUseCase {
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
    
    func execute(_ address: String, type: FootprintSortType) -> [NoteEntity] {
        var list = self.noteRepository.loadNotes(address: address)
        var result: [NoteEntity] = []
        
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
        
        for note in list {
            if let category = self.categoryRepository.loadCategory(note.categoryId) {
                let members = self.memberRepository.loadMembers(note.memberIds)
                result.append(
                    NoteEntity(
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
                        members: members
                    )
                )
            }
        }

        return result
    }
}
