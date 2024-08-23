//
//  Note.swift
//  Footprint
//
//  Created by sandy on 8/23/24.
//

import Foundation
import SwiftUI

public struct Note {
    var id: String
    var title: String
    var content: String
    var createdAt: Date
    var images: [UIImage]
    var category: Category
    var peopleWith: [PeopleWith]
    var isStar: Bool
}
