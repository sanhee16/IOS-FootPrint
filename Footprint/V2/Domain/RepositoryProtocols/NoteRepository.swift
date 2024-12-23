//
//  NoteRepository.swift
//  Footprint
//
//  Created by sandy on 8/22/24.
//

import Foundation
import RealmSwift

protocol NoteRepository {
    func saveNote(
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
    )
    func updateNote(
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
    )
    func deleteNote(_ id: String) -> String?
    func loadNotes() -> [NoteEntity.DAO]
    func loadNote(id: String) -> NoteEntity.DAO?
    func loadNotes(address: String) -> [NoteEntity.DAO]
    func toggleStar(id: String) -> Bool
    func deleteImageUrl(_ id: String, url: String)
}
