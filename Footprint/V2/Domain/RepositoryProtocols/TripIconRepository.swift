//
//  TripIconRepository.swift
//  Footprint
//
//  Created by sandy on 11/13/24.
//

protocol TripIconRepository {
    func saveTripIcon(icon: TripIcon) -> Result<String, DBError>
    func deleteTripIcon(id: String) -> Result<String, DBError>
    func loadTripIcons() -> Result<[TripIconEntity.DAO], DBError>
    func loadTripIcon(id: String) -> Result<TripIconEntity.DAO, DBError>
}
