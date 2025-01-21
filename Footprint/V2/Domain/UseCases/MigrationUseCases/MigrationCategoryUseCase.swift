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
                let tag: Int = item.tag
                if let pinType = PinType(rawValue: item.pinType),
                    let pinColor = PinColor(rawValue: item.pinColor) {
                    do {
                        let id = try self.migrationRepository.saveTag(tag).get()
                        self.saveCategoryUseCase.execute(
                            id,
                            name: item.name,
                            color: pinColor.v2Color,
                            icon: pinType.v2Icon,
                            isDeletable: true
                        )
                    } catch {
                        continue
                    }
                }
            }
            
            return .success(Void())
            
        case .failure(let failure):
            return .failure(failure)
        }
    }
}
