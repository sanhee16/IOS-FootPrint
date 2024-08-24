//
//  DeleteMemberUseCase.swift
//  Footprint
//
//  Created by sandy on 8/24/24.
//

import Foundation

class DeleteMemberUseCase {
    let memberRepository: MemberRepository
    
    init(memberRepository: MemberRepository) {
        self.memberRepository = memberRepository
    }
    
    func execute(_ id: String) {
        return self.memberRepository.deleteMember(id)
    }
}


