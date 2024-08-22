//
//  RealNoteRepository.swift
//  Footprint
//
//  Created by sandy on 8/22/24.
//

import Foundation
import RealmSwift

class RealNoteRepository: NoteRepository {
    func saveNotes(_ data: NoteData) {
        let realm = try! Realm()
        
        try! realm.write {
            realm.add(data, update: .modified)
        }
    }
    
    func deleteNote(_ id: String) {
        let realm = try! Realm()
        
        // 데이터를 가져와서 필터링
        let deleteItem = realm.objects(NoteData.self)
            .filter { $0.id == id }
            .first
        guard let deleteItem = deleteItem else { return }
        
        // 데이터 삭제
        try! realm.write {
            realm.delete(deleteItem)
        }
    }
    
    func getNotes() -> [NoteData] {
        let realm = try! Realm()
        let list = Array(realm.objects(NoteData.self))
        return list
    }
    
    
}
