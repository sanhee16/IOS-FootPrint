//
//  FirestoreModel.swift
//  Footprint
//
//  Created by Studio-SJ on 2023/03/22.
//

import Foundation
import FirebaseCore
import FirebaseFirestore


struct PremiumModel: Codable {
    @DocumentID var documentID: String?
    var name: String
    var isUsing: Bool
    
    static func == (lhs: PremiumModel, rhs: PremiumModel) -> Bool {
        return lhs.documentID == rhs.documentID
    }
    
    private enum CodingKeys: String, CodingKey {
        case documentID = "document_id"
        case name
        case isUsing
    }
    
}

struct ReviewModel: Codable {
    @DocumentID var documentID: String?
    var content: String
    var star: Int
    
    static func == (lhs: ReviewModel, rhs: ReviewModel) -> Bool {
        return lhs.documentID == rhs.documentID
    }
    
    private enum CodingKeys: String, CodingKey {
        case documentID = "document_id"
        case content
        case star
    }
    
}
