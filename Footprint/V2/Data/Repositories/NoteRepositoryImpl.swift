//
//  NoteRepositoryImpl.swift
//  Footprint
//
//  Created by sandy on 8/22/24.
//

import Foundation
import RealmSwift

class NoteRepositoryImpl: NoteRepository {
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
    ) {
        var note = Note(
            id: id ?? UUID().uuidString,
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
        let realm = try! Realm()
        let imageUrls: List<String> = List()
        let peopleWithIds: List<String> = List()
        
        note.imageUrls.forEach {
            imageUrls.append($0)
        }
        note.peopleWithIds.forEach {
            peopleWithIds.append($0)
        }
        
        let data: NoteData = NoteData(
            id: note.id,
            title: note.title,
            content: note.content,
            imageUrls: imageUrls,
            createdAt: note.createdAt,
            latitude: note.latitude,
            longitude: note.longitude,
            peopleWithIds: peopleWithIds,
            categoryId: note.categoryId,
            address: note.address,
            isStar: note.isStar
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
    
    func loadNote(id: String) -> Note? {
        let realm = try! Realm()
        guard let data = realm.objects(NoteData.self).filter("id == %s", id).first else { return nil }
        return data.mapper()
    }
    
    func loadNote(address: String) -> [Note] {
        let realm = try! Realm()
        let list: [NoteData] = Array(realm.objects(NoteData.self).filter("address == %s", address))
        return list.map { $0.mapper() }
    }
    
    func toggleStar(id: String) -> Bool {
        let realm = try! Realm()
        guard let item = realm.objects(NoteData.self).filter({ $0.id == id }).first else { return false }
        try! realm.write {
            item.isStar = !item.isStar
            realm.add(item, update: .modified)
        }
        
        guard let item = realm.objects(NoteData.self).filter ({ $0.id == id }).first else { return false }
        return item.isStar
    }
    
    func deleteImageUrl(_ id: String, url: String) {
        let realm = try! Realm()
        guard let item = realm.objects(NoteData.self).filter({ $0.id == id }).first else { return }
        try! realm.write {
            if let idx = item.imageUrls.firstIndex(where: { $0 == url }) {
                item.imageUrls.remove(at: idx)
                realm.add(item, update: .modified)
            }
        }
        return
    }
}
