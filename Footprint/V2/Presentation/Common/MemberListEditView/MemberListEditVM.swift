//
//  PeopleWithListEditVM.swift
//  Footprint
//
//  Created by sandy on 8/24/24.
//

import Foundation
import Factory


class MemberListEditVM: BaseViewModel {
    @Injected(\.loadMembersUseCase) var loadMembersUseCase
    @Injected(\.deleteMemberUseCase) var deleteMemberUseCase
    @Published var members: [MemberEntity] = []
    @Published var deleteMember: MemberEntity? = nil
    
    override init() {
        super.init()
    }
    
    func loadMembers() {
        self.members = loadMembersUseCase.execute()
    }
    
    func onDelete() {
        guard let member = deleteMember, let idx = members.firstIndex(where: { $0 == member }), let id = member.id else { return }
        self.members.remove(at: idx)
        self.deleteMemberUseCase.execute(id)
        self.loadMembers()
    }
}
