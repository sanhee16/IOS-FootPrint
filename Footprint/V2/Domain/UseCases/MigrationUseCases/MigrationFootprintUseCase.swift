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
                do {
                    var memberIds: [String] = []
                    
                    try item.peopleWithIds.forEach { id in
                        let newId = try self.migrationRepository.getMemberId(id).get()
                        memberIds.append(newId)
                    }
                    
                    let categoryId = try self.migrationRepository.getCategoryId(item.tag).get()
                    self.updateNoteUseCase.execute(
                        id: item.id.stringValue,
                        title: item.title,
                        content: item.content,
                        createdAt: item.createdAt,
                        imageUrls: item.images.map({ url in String(url) }),
                        categoryId: categoryId,
                        memberIds: memberIds,
                        isStar: item.isStar,
                        latitude: item.latitude,
                        longitude: item.longitude,
                        address: item.address ?? ""
                    )
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
