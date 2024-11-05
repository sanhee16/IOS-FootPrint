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
}

var tempNote: TempNote? = nil
