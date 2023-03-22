//
//  FirestoreModel.swift
//  Footprint
//
//  Created by Studio-SJ on 2023/03/22.
//

import Foundation
import FirebaseCore
import FirebaseFirestore
import FirebaseFirestoreSwift


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
    
//    init(id: String, name: String, isUsing: Bool) {
//        self.id = id
//        self.name = name
//        self.isUsing = isUsing
//    }
//
//    init(from decoder: Decoder) throws {
//        let values = try decoder.container(keyedBy: CodingKeys.self)
//        id = try values.decode(String.self, forKey: .id)
//        name = try values.decode(String.self, forKey: .name)
//        isUsing = try values.decode(Bool.self, forKey: .isUsing)
//    }
}
