//
//  SError.swift
//  Footprint
//
//  Created by Studio-SJ on 2023/01/12.
//

import Foundation

public enum GoogleError: Error {
    case Message(message: String)
    case ReferenceFailed
    case NotFound
    case ApiError(error: GoogleErrorResponse)
    
    func toError() -> Error {
        return self as Error
    }
}
