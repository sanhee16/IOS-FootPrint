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
    
    func execute(_ id: String?, name: String, image: String, intro: String) {
        self.memberRepository.addMember(id, name: name, image: image, intro: intro)
    }
}


