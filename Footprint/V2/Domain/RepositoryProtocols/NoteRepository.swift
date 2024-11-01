//
//  NoteRepository.swift
//  Footprint
//
//  Created by sandy on 8/22/24.
//

import Foundation
import RealmSwift

protocol NoteRepository {
    func saveNotes(_ data: Note)
    func deleteNote(_ id: String)
    func loadNotes() -> [Note]
    func loadNote(id: String) -> Note?
    func loadNote(address: String) -> [Note]
}
