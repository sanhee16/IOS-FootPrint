//
//  MemberRepository.swift
//  Footprint
//
//  Created by sandy on 8/24/24.
//

import Foundation
import RealmSwift

protocol MemberRepository {
    func addMember(_ id: String?, name: String, image: String, intro: String)
    func deleteMember(_ id: String)
    func loadMembers() -> [MemberEntity]
}


