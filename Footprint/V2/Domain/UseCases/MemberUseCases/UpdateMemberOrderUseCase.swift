//
//  UpdateMemberOrderUseCase.swift
//  Footprint
//
//  Created by sandy on 11/6/24.
//

class UpdateMemberOrderUseCase {
    let memberRepository: MemberRepository
    
    init(memberRepository: MemberRepository) {
        self.memberRepository = memberRepository
    }
    
    func execute(_ members: [MemberEntity]) {
        self.memberRepository.updateOrder(members)
    }
}
