//
//  MigrationUseCase.swift
//  Footprint
//
//  Created by sandy on 1/21/25.
//

import Foundation

class MigrationUseCase {
    let migrationFootprintUseCase: MigrationFootprintUseCase
    let migrationTripUseCase: MigrationTripUseCase
    let migrationMemberUseCase: MigrationMemberUseCase
    let migrationCategoryUseCase: MigrationCategoryUseCase
    
    init(migrationFootprintUseCase: MigrationFootprintUseCase, migrationTripUseCase: MigrationTripUseCase, migrationMemberUseCase: MigrationMemberUseCase, migrationCategoryUseCase: MigrationCategoryUseCase) {
        self.migrationFootprintUseCase = migrationFootprintUseCase
        self.migrationTripUseCase = migrationTripUseCase
        self.migrationMemberUseCase = migrationMemberUseCase
        self.migrationCategoryUseCase = migrationCategoryUseCase
    }
    
    func execute() -> Result<Void, DBError> {
        let result = self.migrationCategoryUseCase.execute()
            .flatMap { _ in
                return self.migrationMemberUseCase.execute()
            }
            .flatMap { _ in
                return self.migrationFootprintUseCase.execute()
            }
            .flatMap { _ in
                return self.migrationTripUseCase.execute()
            }
            .flatMapError { error in
                return .failure(error)
            }
        switch result {
        case .success(let success):
            return .success(Void())
        case .failure(let failure):
            return .failure(failure)
        }
        
    }
}
