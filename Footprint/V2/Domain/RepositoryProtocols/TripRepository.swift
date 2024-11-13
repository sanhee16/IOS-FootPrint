//
//  TripRepository.swift
//  Footprint
//
//  Created by sandy on 11/13/24.
//

import Foundation

protocol TripRepository {
    func saveTrip(
        title: String,
        content: String,
        iconId: String,
        footprintIds: [String],
        startAt: Int,
        endAt: Int
    ) -> Result<String, DBError>
    
    func updateTrip(
        id: String,
        title: String,
        content: String,
        iconId: String,
        footprintIds: [String],
        startAt: Int,
        endAt: Int
    ) -> Result<String, DBError>
    
    func deleteTrip(_ id: String) -> Result<String, DBError>
    func loadTrips() -> Result<[TripEntity.DAO], DBError>
    func loadTrip(_ id: String) -> Result<TripEntity.DAO, DBError>
}
