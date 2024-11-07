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
    func updateMember(_ id: String, idx: Int, name: String, image: String, intro: String)
    func deleteMember(_ id: String)
    func loadMembers() -> [MemberEntity]
    func loadMembers(_ ids: [String]) -> [MemberEntity]
    func updateOrder(_ members: [MemberEntity])
}


