//
//  GetLocationUseCase.swift
//  Footprint
//
//  Created by sandy on 12/20/24.
//

import Foundation

class GetLocationUseCase {
    let locationRepository: LocationRepository
    
    init(locationRepository: LocationRepository) {
        self.locationRepository = locationRepository
    }
    
    func execute(_ placeId: String) async -> Result<Location, DomainRemoteError> {
        return await self.locationRepository.getLoaction(placeId)
    }
}
