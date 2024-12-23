//
//  TemporaryNoteService.swift
//  Footprint
//
//  Created by sandy on 11/19/24.
//

import Foundation
import Photos
import PhotosUI
import _PhotosUI_SwiftUI
import UIKit

class TemporaryNoteService {
    private var temporaryNote: TemporaryNote?
    
    init(loadNoteWithIdUseCase: LoadNoteWithIdUseCase) {
        self.temporaryNote = nil
    }
    
    func save(
        type: EditNoteType,
        id: String? = nil,
        isStar: Bool,
        title: String,
        content: String,
        address: String,
        createdAt: Date,
        category: CategoryEntity? = nil,
        images: [UIImage] = [],
        imageUrls: [String] = [],
        selectedPhotos: [PhotosPickerItem] = [],
        members: [MemberEntity] = [],
        location: Location
    ) {
        self.temporaryNote = TemporaryNote()
        
        self.temporaryNote?.type = type
        self.temporaryNote?.id = id
        self.temporaryNote?.isStar = isStar
        self.temporaryNote?.title = title
        self.temporaryNote?.content = content
        self.temporaryNote?.address = address
        self.temporaryNote?.createdAt = createdAt
        self.temporaryNote?.category = category
        self.temporaryNote?.images = images
        self.temporaryNote?.imageUrls = imageUrls
        self.temporaryNote?.selectedPhotos = selectedPhotos
        self.temporaryNote?.members = members
        self.temporaryNote?.location = location
    }
    
    func load() -> TemporaryNote? {
        return self.temporaryNote
    }
    
    func clear() {
        self.temporaryNote = nil
    }
    
    func updateLocation(address: String, location: Location) {
        self.temporaryNote?.address = address
        self.temporaryNote?.location = location
    }
}
