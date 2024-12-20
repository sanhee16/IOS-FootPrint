//
//  LocationRepositoryImpl.swift
//  Footprint
//
//  Created by sandy on 12/20/24.
//

import Foundation

class LocationRepositoryImpl: LocationRepository {
    let dataProvider: GoogleRemoteDataProvider
    
    init(dataProvider: GoogleRemoteDataProvider) {
        self.dataProvider = dataProvider
    }
    
    func getLoaction(_ placeId: String) async -> Result<Location, DomainRemoteError> {
        return await self.dataProvider.fetchGeocoding(placeId)
            .flatMap { data in
                if let location = data.results?.first?.geometry.location {
                    return .success(Location(latitude: location.lat, longitude: location.lng))
                }
                return .failure(.notFound)
            }
            .mapError { error in
                return error.toDomainError()
            }
    }
}
