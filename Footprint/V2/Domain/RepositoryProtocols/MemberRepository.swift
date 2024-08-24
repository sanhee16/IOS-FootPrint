//
//  MemberRepository.swift
//  Footprint
//
//  Created by sandy on 8/24/24.
//

import Foundation
import RealmSwift

protocol MemberRepository {
    func addMember(_ member: Member)
    func deleteMember(_ id: String)
    func loadMembers() -> [Member]
}


