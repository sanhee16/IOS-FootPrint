//
//  EditNoteTempStorage.swift
//  Footprint
//
//  Created by sandy on 8/23/24.
//

import Foundation

class EditNoteTempStorage {
    static var title: String = ""
    static var isStar: Bool = false
    static var content: String = ""
    static var address: String = ""
    static var createdAt: Date = Date()
    static var category: CategoryEntity? = nil
    

    static func clear() {
        self.title = ""
        self.isStar = false
        self.content = ""
        self.address = ""
        self.createdAt = Date()
        self.category = nil
    }
    
    static func save(
        title: String,
        isStar: Bool,
        content: String,
        address: String,
        createdAt: Date,
        category: CategoryEntity?
    ) {
        self.title = title
        self.isStar = isStar
        self.content = content
        self.address = address
        self.createdAt = createdAt
        self.category = category
    }
}
