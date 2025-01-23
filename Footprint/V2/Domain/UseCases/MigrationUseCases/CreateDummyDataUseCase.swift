//
//  CreateDummyDataUseCase.swift
//  Footprint
//
//  Created by sandy on 1/21/25.
//

import Foundation
import RealmSwift

class CreateDummyDataUseCase {
    
    
    func execute() {
        let realm = try! Realm()
        try! realm.write {
            
            // 카테고리
            realm.add(Category(tag: 0, name: "카테고리 0", pinType: .cake, pinColor: .pin0), update: .modified)
            realm.add(Category(tag: 1, name: "카테고리 1", pinType: .like, pinColor: .pin3), update: .modified)
            realm.add(Category(tag: 2, name: "카테고리 2", pinType: .happy, pinColor: .pin5), update: .modified)
            realm.add(Category(tag: 3, name: "카테고리 3", pinType: .done, pinColor: .pin2), update: .modified)
            
            
            // 함께한 사람
            realm.add(PeopleWith(id: 0, name: "사람 0", image: "", intro: "사람 0 설명"), update: .modified)
            realm.add(PeopleWith(id: 1, name: "사람 1", image: "", intro: "사람 1 설명"), update: .modified)
            realm.add(PeopleWith(id: 2, name: "사람 2", image: "", intro: "사람 2 설명"), update: .modified)
            realm.add(PeopleWith(id: 3, name: "사람 3", image: "", intro: "사람 3 설명"), update: .modified)
            
            // 발자국
            let peopleWithIds: List<Int> = List<Int>()
            peopleWithIds.append(1)
            peopleWithIds.append(2)
            
            realm.add(
                FootPrint(
                    title: "발자국 0",
                    content: "발자국 0의 설명~",
                    images: List(),
                    createdAt: Date(),
                    latitude: 37.785934000000005,
                    longitude: -122.40611700000001,
                    tag: 0,
                    peopleWithIds: peopleWithIds,
                    address: "",
                    isStar: true
                ),
                update: .modified
            )
            
            realm.add(
                FootPrint(
                    title: "발자국 1",
                    content: "발자국 1의 설명~",
                    images: List(),
                    createdAt: Date(),
                    latitude: 37.785934000000005,
                    longitude: -122.40611700000001,
                    tag: 2,
                    peopleWithIds: peopleWithIds,
                    address: "",
                    isStar: true
                ),
                update: .modified
            )
            
            peopleWithIds.removeAll()
            peopleWithIds.append(2)
            peopleWithIds.append(3)
            realm.add(
                FootPrint(
                    title: "발자국 2",
                    content: "발자국 2의 설명~",
                    images: List(),
                    createdAt: Date(),
                    latitude: 37.786434,
                    longitude: -122.406317,
                    tag: 1,
                    peopleWithIds: peopleWithIds,
                    address: "",
                    isStar: false
                ),
                update: .modified
            )
            
            
            // 발자취
            let footprints: List<FootPrint> = List<FootPrint>()
            let items = realm.objects(FootPrint.self)
            items.forEach {
                footprints.append($0)
            }
            
            realm.add(
                Travel(
                    footprints: footprints,
                    title: "title~",
                    intro: "intro",
                    color: "#121212",
                    fromDate: Date(),
                    toDate: Date(),
                    isStar: true,
                    deleteTime: Int(Date().timeIntervalSince1970)
                ),
                update: .modified
            )
            
            realm.add(
                Travel(
                    footprints: footprints,
                    title: "title2222",
                    intro: "intro222222222",
                    color: "#121212",
                    fromDate: Date(),
                    toDate: Date(),
                    isStar: true,
                    deleteTime: Int(Date().timeIntervalSince1970)
                ),
                update: .modified
            )
        }
    }
    
}
