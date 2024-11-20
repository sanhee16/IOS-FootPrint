//
//  TemporaryNote.swift
//  Footprint
//
//  Created by sandy on 11/18/24.
//

import Foundation
import Photos
import PhotosUI
import _PhotosUI_SwiftUI
import UIKit

public final class TemporaryNote {
    var id: String? = nil
    var isStar: Bool = false
    var title: String = ""
    var content: String = ""
    var address: String = ""
    var createdAt: Date = Date()
    var category: CategoryEntity? = nil
    var images: [UIImage] = []
    var imageUrls: [String] = []
    var selectedPhotos: [PhotosPickerItem] = []
    var members: [MemberEntity] = []
    var location: Location? = nil
    
    init() {
        
    }
}
