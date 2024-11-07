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
        let lastIdx: Int = (realm.objects(Member.self).map({ $0.idx }).max() ?? 0)
        
        let item = Member(id: id ?? UUID().uuidString, idx: lastIdx + 1, name: name, image: image, intro: intro)
        do {
            try realm.write {
                realm.add(item, update: .modified)
            }
        } catch {
            print("Error during write transaction: \(error.localizedDescription)")
        }
    }
    
    func updateMember(_ id: String, idx: Int, name: String, image: String, intro: String) {
        let realm = try! Realm()
        let item = Member(id: id, idx: idx, name: name, image: image, intro: intro)
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
        realm.objects(Member.self).sorted(by: { lhs, rhs in
            lhs.idx < rhs.idx
        }).forEach { m in
            list.append(Member(id: m.id, idx: m.idx, name: m.name, image: m.image, intro: m.intro).toMemberEntity())
        }
        return list
    }
    
    func loadMembers(_ ids: [String]) -> [MemberEntity]  {
        let realm = try! Realm()
        var list: [MemberEntity] = []
        
        ids.forEach { id in
            if let m = realm.objects(Member.self).filter("id == %s", id).first {
                list.append(
                    Member(
                        id: m.id,
                        idx: m.idx,
                        name: m.name,
                        image: m.image,
                        intro: m.intro
                    ).toMemberEntity()
                )
            }
        }
        return list
    }
    
    func updateOrder(_ members: [MemberEntity]) {
        let realm = try! Realm()
//        guard let item = realm.objects(Member.self).filter({ $0.id == id }).first else { return }
        
        try! realm.write {
            let preList = realm.objects(Member.self)
            let postList = members.map({ Member(id: $0.id, idx: 0, name: $0.name, image: $0.image, intro: $0.intro) })
            postList.indices.forEach { i in
                postList[i].idx = i
            }
            preList.forEach { item in
                realm.delete(item)
            }
            postList.forEach { item in
                realm.add(item, update: .modified)
            }
        }
    }
}
