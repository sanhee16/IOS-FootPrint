//
//  UpdateMemberUseCase.swift
//  Footprint
//
//  Created by sandy on 8/24/24.
//

import Foundation

class UpdateMemberUseCase {
    let memberRepository: MemberRepository
    
    init(memberRepository: MemberRepository) {
        self.memberRepository = memberRepository
    }
    
    func execute(_ member: Member) {
        self.memberRepository.addMember(member)
    }
}


