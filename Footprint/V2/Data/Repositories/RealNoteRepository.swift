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
    
    func loadNotes() -> [NoteData] {
        let realm = try! Realm()
        var list: [NoteData] = []
        realm.objects(NoteData.self).forEach { n in
            list.append(
                NoteData(id: n.id, title: n.title, content: n.content, images: n.images, createdAt: n.createdAt, latitude: n.latitude, longitude: n.longitude, peopleWithIds: n.peopleWithIds, categoryId: n.categoryId, address: n.address, isStar: n.isStar)
                )
        }
        return list
    }
    
    
}
