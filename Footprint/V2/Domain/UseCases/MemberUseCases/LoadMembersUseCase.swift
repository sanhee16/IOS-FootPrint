//
//  LoadMembersUseCase.swift
//  Footprint
//
//  Created by sandy on 8/24/24.
//

import Foundation

class LoadMembersUseCase {
    let memberRepository: MemberRepository
    
    init(memberRepository: MemberRepository) {
        self.memberRepository = memberRepository
    }
    
    func execute() -> [Member] {
        return self.memberRepository.loadMembers()
    }
}

