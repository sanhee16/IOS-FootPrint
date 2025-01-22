//
//  MigrationMemberUseCase.swift
//  Footprint
//
//  Created by sandy on 1/21/25.
//

import Foundation

class MigrationMemberUseCase {
    let migrationRepository: MigrationRepository
    let updateMemberUseCase: UpdateMemberUseCase
    
    init(migrationRepository: MigrationRepository, updateMemberUseCase: UpdateMemberUseCase) {
        self.migrationRepository = migrationRepository
        self.updateMemberUseCase = updateMemberUseCase
    }
    
    func execute() -> Result<Void, DBError> {
        let result = self.migrationRepository.loadV1Members()
        
        
        switch result {
        case .success(let list):
            if list.isEmpty {
                return .success(Void())
            }
            
            var idx: Int = 0
            for item in list {
                do {
                    let id = try self.migrationRepository.saveMemberId(item.id).get()
                    updateMemberUseCase.execute(
                        id,
                        idx: idx,
                        name: item.name,
                        image: ImageManager.shared.getSavedImage(named: item.image),
                        intro: item.intro
                    )
                    idx += 1
                } catch {
                    continue
                }
            }
            
            return .success(Void())
            
        case .failure(let failure):
            return .failure(failure)
        }
    }
}
