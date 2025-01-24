//
//  MigrationFootprintUseCase.swift
//  Footprint
//
//  Created by sandy on 1/21/25.
//

import Foundation

class MigrationFootprintUseCase {
    let migrationRepository: MigrationRepository
    let updateNoteUseCase: UpdateNoteUseCase
    
    init(migrationRepository: MigrationRepository, updateNoteUseCase: UpdateNoteUseCase) {
        self.migrationRepository = migrationRepository
        self.updateNoteUseCase = updateNoteUseCase
    }
    
    func execute() -> Result<Void, DBError> {
        let result = self.migrationRepository.loadV1Footprints()
        
        
        switch result {
        case .success(let list):
            if list.isEmpty {
                return .success(Void())
            }
            
            for item in list {
                self.updateNoteUseCase.execute(
                        id: item.id,
                        title: item.title,
                        content: item.content,
                        createdAt: item.createdAt,
                        imageUrls: item.images.map({ url in String(url) }),
                        categoryId: item.categoryId,
                        memberIds: item.memberIds,
                        isStar: item.isStar,
                        latitude: item.latitude,
                        longitude: item.longitude,
                        address: item.address
                    )
            }
            return .success(Void())
            
        case .failure(let failure):
            return .failure(failure)
        }
    }
}
