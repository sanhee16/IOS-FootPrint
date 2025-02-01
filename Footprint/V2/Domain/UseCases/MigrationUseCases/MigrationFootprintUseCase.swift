//
//  MigrationFootprintUseCase.swift
//  Footprint
//
//  Created by sandy on 1/21/25.
//

import Foundation
import CoreLocation

class MigrationFootprintUseCase {
    let migrationRepository: MigrationRepository
    let updateNoteUseCase: UpdateNoteUseCase
    let getAddressUseCase: GetAddressUseCase
    
    init(migrationRepository: MigrationRepository, updateNoteUseCase: UpdateNoteUseCase, getAddressUseCase: GetAddressUseCase) {
        self.migrationRepository = migrationRepository
        self.updateNoteUseCase = updateNoteUseCase
        self.getAddressUseCase = getAddressUseCase
    }
    
    func execute() -> Result<Void, DBError> {
        let result = self.migrationRepository.loadV1Footprints()
        
        
        switch result {
        case .success(let list):
            if list.isEmpty {
                return .success(Void())
            }
            
            for item in list {
                Task {
                    let address = await self.getAddressUseCase.execute(CLLocation(latitude: item.latitude, longitude: item.longitude))
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
                            address: address
                        )
                }
            }
            return .success(Void())
            
        case .failure(let failure):
            return .failure(failure)
        }
    }
}
