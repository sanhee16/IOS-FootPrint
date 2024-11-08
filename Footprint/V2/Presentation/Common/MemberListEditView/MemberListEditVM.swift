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
    @Injected(\.updateMemberOrderUseCase) var updateMemberOrderUseCase
    @Published var members: [MemberEntity] = [] {
        didSet {
            self.updateOrder()
//            print("members: \(members.map({ $0.name }))")
        }
    }
    @Published var deleteMember: MemberEntity? = nil
    @Published var isLoading: Bool = false
    private var saveTimer: Timer?
    
    override init() {
        super.init()
    }
    
    func loadMembers() {
        print("loadMembers")
        self.members = loadMembersUseCase.execute()
    }
    
    func onDelete() {
        guard let member = deleteMember, let idx = members.firstIndex(where: { $0 == member }) else { return }
        self.members.remove(at: idx)
        self.deleteMemberUseCase.execute(member.id)
        self.loadMembers()
    }
    
    func updateOrder() {
        // 이전 타이머 취소
        saveTimer?.invalidate()
        
        // 0.7초후에 저장
        saveTimer = Timer.scheduledTimer(withTimeInterval: 0.7, repeats: false) { _ in
            self.updateMemberOrderUseCase.execute(self.members)
        }
    }
}
