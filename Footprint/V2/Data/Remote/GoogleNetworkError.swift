//
//  GoogleNetworkError.swift
//  Footprint
//
//  Created by sandy on 11/26/24.
//

import Foundation

enum GoogleNetworkError: Error {
    case notFound
    case invalidParameter(message: String)
    case decodeFail
    case serverError
    case unknown
}

extension GoogleNetworkError {
    func toDomainError() -> DomainRemoteError {
        switch self {
        case .notFound:
            return .dataNotAvailable
        case .invalidParameter(_):
            return .invalidInput
        case .decodeFail:
            return .dataNotAvailable
        case .serverError:
            return .dataNotAvailable
        case .unknown:
            return .unknown
        }
    }
    
}
