//
//  NoteRepository.swift
//  Footprint
//
//  Created by sandy on 8/22/24.
//

import Foundation
import RealmSwift

protocol NoteRepository {
    func saveNotes(_ data: NoteData)
    func deleteNote(_ id: String)
    func loadNotes() -> [NoteData]
}
