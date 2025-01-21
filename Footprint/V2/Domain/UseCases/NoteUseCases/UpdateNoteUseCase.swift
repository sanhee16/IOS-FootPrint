//
//  UpdateNoteUseCase.swift
//  Footprint
//
//  Created by sandy on 11/20/24.
//

class UpdateNoteUseCase {
    let noteRepository: NoteRepository
    
    init(noteRepository: NoteRepository) {
        self.noteRepository = noteRepository
    }
    
    func execute(
        id: String,
        title: String,
        content: String,
        createdAt: Int,
        imageUrls: [String],
        categoryId: String,
        memberIds: [String],
        isStar: Bool,
        latitude: Double,
        longitude: Double,
        address: String
    ) {
        self.noteRepository.updateNote(
            id: id,
            title: title,
            content: content,
            createdAt: createdAt,
            imageUrls: imageUrls,
            categoryId: categoryId,
            memberIds: memberIds,
            isStar: isStar,
            latitude: latitude,
            longitude: longitude,
            address: address
        )
    }
}
