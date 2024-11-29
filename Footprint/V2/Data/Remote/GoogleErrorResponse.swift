//
//  GoogleErrorResponse.swift
//  Footprint
//
//  Created by sandy on 11/26/24.
//

import Foundation

public class GoogleErrorResponse: Codable {
    let status: String?
    let errorMessage: String?
    
    private enum CodingKeys: String, CodingKey {
        case status = "status"
        case errorMessage = "error_message"
    }
}
