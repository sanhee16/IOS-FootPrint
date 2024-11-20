//
//  TempNote.swift
//  Footprint
//
//  Created by sandy on 11/5/24.
//

import Foundation
import Photos
import PhotosUI
import _PhotosUI_SwiftUI
import UIKit

public struct TempNote {
    var id: String?
    var isStar: Bool
    var title: String
    var content: String
    var address: String
    var createdAt: Date
    var categories: [CategoryEntity]
    var category: CategoryEntity?
    var images: [UIImage]
    var imageUrls: [String]
    var selectedPhotos: [PhotosPickerItem]
    var members: [MemberEntity]
    var location: Location
    
    init(id: String? = nil, isStar: Bool, title: String, content: String, address: String, createdAt: Date, categories: [CategoryEntity], category: CategoryEntity? = nil, images: [UIImage], imageUrls: [String], selectedPhotos: [PhotosPickerItem], members: [MemberEntity], location: Location) {
        self.id = id
        self.isStar = isStar
        self.title = title
        self.content = content
        self.address = address
        self.createdAt = createdAt
        self.categories = categories
        self.category = category
        self.images = images
        self.imageUrls = imageUrls
        self.selectedPhotos = selectedPhotos
        self.members = members
        self.location = location
    }
}

var tempNote: TempNote? = nil
