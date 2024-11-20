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
    private let loadNoteUseCaseWithId: LoadNoteUseCaseWithId
    
    init(loadNoteUseCaseWithId: LoadNoteUseCaseWithId) {
        self.temporaryNote = nil
        self.loadNoteUseCaseWithId = loadNoteUseCaseWithId
    }
    
    func saveTempNote(
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
    
    func loadTempNote(_ id: String?) -> TemporaryNote? {
        if let temporaryNote = self.temporaryNote { return temporaryNote }
        self.temporaryNote = TemporaryNote()
        
        guard let id = id, let note = self.loadNoteUseCaseWithId.execute(id) else {
            return self.temporaryNote!
        }
                
        self.temporaryNote?.id = id
        self.temporaryNote?.isStar = note.isStar
        self.temporaryNote?.title = note.title
        self.temporaryNote?.content = note.content
        self.temporaryNote?.address = note.address
        self.temporaryNote?.createdAt = Date(timeIntervalSince1970: Double(note.createdAt))
        self.temporaryNote?.category = note.category
        self.temporaryNote?.imageUrls = note.imageUrls
        self.temporaryNote?.location = Location(latitude: note.latitude, longitude: note.longitude)
        self.temporaryNote?.selectedPhotos = []
        self.temporaryNote?.members = note.members
        
        return self.temporaryNote
    }
    
    func updateTempLocation(
        address: String = "",
        location: Location? = nil
    ) -> TemporaryNote? {
        self.temporaryNote = self.temporaryNote ?? TemporaryNote()
        self.temporaryNote?.address = address
        self.temporaryNote?.location = location
        return self.temporaryNote
    }
    
    func clear() {
        self.temporaryNote = nil
    }
}
