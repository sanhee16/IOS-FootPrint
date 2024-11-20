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
    private let noteRepository: NoteRepository
    private let categoryRepository: CategoryRepository
    private let memberRepository: MemberRepository
    
    init(
        noteRepository: NoteRepository,
        categoryRepository: CategoryRepository,
        memberRepository: MemberRepository
    ) {
        self.temporaryNote = nil
        self.noteRepository = noteRepository
        self.categoryRepository = categoryRepository
        self.memberRepository = memberRepository
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
        guard
            let id = id,
            var note = self.noteRepository.loadNote(id: id),
            let category = self.categoryRepository.loadCategory(note.categoryId) else {
            self.temporaryNote = TemporaryNote()
            return self.temporaryNote!
        }
        self.temporaryNote = TemporaryNote()
        
        let peopleWith = self.memberRepository.loadMembers(note.peopleWithIds)
        note.category = category
        note.peopleWith = peopleWith
        
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
        self.temporaryNote?.members = note.peopleWith ?? []
        
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
