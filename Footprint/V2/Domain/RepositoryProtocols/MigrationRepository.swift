//
//  MigrationRepository.swift
//  Footprint
//
//  Created by sandy on 1/21/25.
//

import Foundation

protocol MigrationRepository {
    func loadV1Categories() -> Result<[CategoryV1], DBError>
    func loadV1Members() -> Result<[MemberV1], DBError>
    func loadV1Trips() -> Result<[TripV1], DBError>
    func loadV1Footprints() -> Result<[FootprintV1], DBError>
}
