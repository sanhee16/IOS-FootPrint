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
            list.forEach {
                updateMemberUseCase.execute(
                    $0.id,
                    idx: idx,
                    name: $0.name,
                    image: ImageManager.shared.getSavedImage(named: $0.image),
                    intro: $0.intro
                )
                idx += 1
            }
            return .success(Void())
            
        case .failure(let failure):
            return .failure(failure)
        }
    }
}
