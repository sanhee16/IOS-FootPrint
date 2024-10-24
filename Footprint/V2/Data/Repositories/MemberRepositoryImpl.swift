//
//  MemberRepositoryImpl.swift
//  Footprint
//
//  Created by sandy on 8/24/24.
//

import Foundation
import RealmSwift

class MemberRepositoryImpl: MemberRepository {
    func addMember(_ id: String?, name: String, image: String, intro: String) {
        let realm = try! Realm()
        let item = Member(id: id, name: name, image: image, intro: intro)
        do {
            try realm.write {
                realm.add(item, update: .modified)
            }
        } catch {
            print("Error during write transaction: \(error.localizedDescription)")
        }
    }
    
    func deleteMember(_ id: String) {
        let realm = try! Realm()
        
        // 데이터를 가져와서 필터링
        let deleteItem = realm.objects(Member.self)
            .filter { $0.id == id }
            .first
        guard let deleteItem = deleteItem else { return }
        
        // 데이터 삭제
        try! realm.write {
            realm.delete(deleteItem)
        }
    }
    
    func loadMembers() -> [MemberEntity] {
        let realm = try! Realm()
        var list: [MemberEntity] = []
        realm.objects(Member.self).forEach { m in
            list.append(Member(id: m.id, name: m.name, image: m.image, intro: m.intro).toMemberEntity())
        }
        return list
    }
}
