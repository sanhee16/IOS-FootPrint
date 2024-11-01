//
//  NoteRepositoryImpl.swift
//  Footprint
//
//  Created by sandy on 8/22/24.
//

import Foundation
import RealmSwift

class NoteRepositoryImpl: NoteRepository {
    func saveNotes(_ data: Note) {
        let realm = try! Realm()
        var imageUrls: List<String> = List()
        var peopleWithIds: List<String> = List()
        data.imageUrls.forEach {
            imageUrls.append($0)
        }
        data.peopleWithIds.forEach {
            peopleWithIds.append($0)
        }
        
        let data: NoteData = NoteData(
            id: data.id,
            title: data.title,
            content: data.content,
            imageUrls: imageUrls,
            createdAt: data.createdAt,
            latitude: data.latitude,
            longitude: data.longitude,
            peopleWithIds: peopleWithIds,
            categoryId: data.categoryId,
            address: data.address,
            isStar: data.isStar
        )
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
    
    func loadNotes() -> [Note] {
        let realm = try! Realm()
        let list: [NoteData] = Array(realm.objects(NoteData.self))
        return list.map { $0.mapper() }
    }
    
    func loadNote(_ id: String) -> Note? {
        let realm = try! Realm()
        guard let data = realm.objects(NoteData.self).filter("id == %s", id).first else { return nil }
        return data.mapper()
    }
    
    func loadNote(_ address: String) -> [Note] {
        let realm = try! Realm()
        var list: [NoteData] = Array(realm.objects(NoteData.self).filter("address == %s", address))
        return list.map { $0.mapper() }
    }
    
    
}
