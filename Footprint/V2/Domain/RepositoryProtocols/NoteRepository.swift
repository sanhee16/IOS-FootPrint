//
//  NoteRepository.swift
//  Footprint
//
//  Created by sandy on 8/22/24.
//

import Foundation
import RealmSwift

protocol NoteRepository {
    func saveNotes(
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
    )
    func deleteNote(_ id: String)
    func loadNotes() -> [Note]
    func loadNote(id: String) -> Note?
    func loadNote(address: String) -> [Note]
    func toggleStar(id: String) -> Bool
    func deleteImageUrl(_ id: String, url: String)
}
