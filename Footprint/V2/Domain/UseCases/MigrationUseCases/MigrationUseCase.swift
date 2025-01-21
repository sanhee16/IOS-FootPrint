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
    let userDefaultManager: Defaults
    
    init(migrationFootprintUseCase: MigrationFootprintUseCase, migrationTripUseCase: MigrationTripUseCase, migrationMemberUseCase: MigrationMemberUseCase, migrationCategoryUseCase: MigrationCategoryUseCase, userDefaultManager: Defaults) {
        self.migrationFootprintUseCase = migrationFootprintUseCase
        self.migrationTripUseCase = migrationTripUseCase
        self.migrationMemberUseCase = migrationMemberUseCase
        self.migrationCategoryUseCase = migrationCategoryUseCase
        self.userDefaultManager = userDefaultManager
    }
    
    func execute() -> Result<Void, DBError> {
        if self.userDefaultManager.isCompleteMigrationV2 {
            return .success(Void())
        }
        
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
            self.userDefaultManager.isCompleteMigrationV2 = true
            return .success(Void())
        case .failure(let failure):
            return .failure(failure)
        }
        
    }
}
