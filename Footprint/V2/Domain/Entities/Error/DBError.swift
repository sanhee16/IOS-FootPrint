//
//  DBError.swift
//  Footprint
//
//  Created by sandy on 11/13/24.
//

enum DBError: Error {
    case notFound
    case wrongParameter
    case unknown
    case failToSave
    case failToDelete
}
