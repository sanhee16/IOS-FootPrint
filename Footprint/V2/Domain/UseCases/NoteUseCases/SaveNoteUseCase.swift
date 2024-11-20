//
//  SaveNoteUseCase.swift
//  Footprint
//
//  Created by sandy on 8/22/24.
//

import Foundation

class SaveNoteUseCase {
    let noteRepository: NoteRepository
    
    init(noteRepository: NoteRepository) {
        self.noteRepository = noteRepository
    }
    
    func execute(
        title: String,
        content: String,
        createdAt: Int,
        imageUrls: [String],
        category: CategoryEntity,
        members: [MemberEntity],
        isStar: Bool,
        latitude: Double,
        longitude: Double,
        address: String
    ) {
        self.noteRepository.saveNote(
                title: title,
                content: content,
                createdAt: createdAt,
                imageUrls: imageUrls,
                categoryId: category.id,
                memberIds: members.compactMap({ $0.id }),
                isStar: isStar,
                latitude: latitude,
                longitude: longitude,
                address: address
        )
    }
}
