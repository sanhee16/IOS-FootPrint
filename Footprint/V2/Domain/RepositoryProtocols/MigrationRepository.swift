//
//  MigrationRepository.swift
//  Footprint
//
//  Created by sandy on 1/21/25.
//

import Foundation

protocol MigrationRepository {
    func loadV1Categories() -> Result<[Category], DBError>
    func loadV1Members() -> Result<[Member], DBError>
    func loadV1Trips() -> Result<[Travel], DBError>
    func loadV1Footprints() -> Result<[FootPrint], DBError>
    
    func saveTag(_ tag: Int) -> Result<String, DBError>
    func getCategoryId(_ tag: Int) -> Result<String, DBError>
}
