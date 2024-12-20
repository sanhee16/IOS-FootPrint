//
//  LocationRepository.swift
//  Footprint
//
//  Created by sandy on 12/20/24.
//

import Foundation

protocol LocationRepository {
    func getLoaction(_ placeId: String) async -> Result<Location, DomainRemoteError>
}
