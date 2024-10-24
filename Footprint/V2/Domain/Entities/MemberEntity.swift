//
//  MemberEntity.swift
//  Footprint
//
//  Created by sandy on 10/24/24.
//

struct MemberEntity: Equatable, Hashable {
    var id: String?
    var name: String
    var image: String
    var intro: String
    
    init(id: String? = nil, name: String, image: String, intro: String) {
        self.id = id
        self.name = name
        self.image = image
        self.intro = intro
    }
}

