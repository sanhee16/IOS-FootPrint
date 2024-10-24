//
//  Member.swift
//  Footprint
//
//  Created by sandy on 8/24/24.
//

import Foundation
import RealmSwift

class Member: Object {
    @Persisted(primaryKey: true) var id: String
    @Persisted var name: String
    @Persisted var image: String
    @Persisted var intro: String
    
    convenience init(id: String? = UUID().uuidString, name: String, image: String? = nil, intro: String) {
        self.init()
        
        self.id = id ?? UUID().uuidString
        self.name = name
        self.image = image ?? ""
        self.intro = intro
    }
    
    func toMemberEntity() -> MemberEntity {
        MemberEntity(
            id: self.id,
            name: self.name,
            image: self.image,
            intro: self.intro
        )
    }
}

