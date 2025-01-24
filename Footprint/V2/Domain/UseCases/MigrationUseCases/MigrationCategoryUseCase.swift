//
//  MigrationCategoryUseCase.swift
//  Footprint
//
//  Created by sandy on 1/21/25.
//

import Foundation

class MigrationCategoryUseCase {
    let migrationRepository: MigrationRepository
    let saveCategoryUseCase: SaveCategoryUseCase
    
    init(migrationRepository: MigrationRepository, saveCategoryUseCase: SaveCategoryUseCase) {
        self.migrationRepository = migrationRepository
        self.saveCategoryUseCase = saveCategoryUseCase
    }
    
    func execute() -> Result<Void, DBError> {
        let result = self.migrationRepository.loadV1Categories()
        switch result {
        case .success(let list):
            if list.isEmpty {
                return .success(Void())
            }
            for item in list {
                self.saveCategoryUseCase.execute(
                    item.id,
                    name: item.name,
                    color: item.color,
                    icon: item.icon,
                    isDeletable: true
                )
            }
            
            return .success(Void())
            
        case .failure(let failure):
            return .failure(failure)
        }
    }
}
