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
        id: String?,
        title: String,
        content: String,
        createdAt: Int,
        imageUrls: [String],
        categoryId: String,
        peopleWithIds: [String],
        isStar: Bool,
        latitude: Double,
        longitude: Double,
        address: String
    ) {
        self.noteRepository.saveNotes(
                id: id,
                title: title,
                content: content,
                createdAt: createdAt,
                imageUrls: imageUrls,
                categoryId: categoryId,
                peopleWithIds: peopleWithIds,
                isStar: isStar,
                latitude: latitude,
                longitude: longitude,
                address: address
        )
    }
}
