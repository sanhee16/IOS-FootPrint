//
//  EditNoteVM.swift
//  Footprint
//
//  Created by sandy on 8/10/24.
//

import Foundation
import Combine
import UIKit
import RealmSwift
import Factory
import Photos
import PhotosUI
import _PhotosUI_SwiftUI

enum EditNoteType {
    case create(address: String, location: Location)
    case update(id: String)
    
    var title: String {
        switch self {
        case .create:
            return "발자국 남기기"
        case .update:
            return "발자국 편집하기"
        }
    }
}

class EditNoteVM: BaseViewModel {
    @Injected(\.deleteNoteUseCase) var deleteNoteUseCase
    @Injected(\.saveNoteUseCase) var saveNoteUseCase
    @Injected(\.updateNoteUseCase) var updateNoteUseCase
    @Injected(\.deleteImageUrlUseCase) var deleteImageUrlUseCase
    @Injected(\.loadCategoriesUseCase) var loadCategoriesUseCase
    @Injected(\.loadMembersUseCase) var loadMembersUseCase
    @Injected(\.permissionService) var permissionService
    @Injected(\.loadNoteWithIdUseCase) var loadNoteWithIdUseCase
    @Injected(\.temporaryNoteService) var temporaryNoteService
    
    @Published var isAvailableToSave: Bool = false
    @Published var isStar: Bool = false
    @Published var title: String = "" { didSet { checkIsAvailableToSave() }}
    @Published var content: String = ""
    @Published var address: String = "" { didSet { checkIsAvailableToSave() }}
    @Published var createdAt: Date = Date()
    @Published var categories: [CategoryEntity] = []
    @Published var category: CategoryEntity? = nil
    @Published var images: [UIImage] = [UIImage]()
    @Published var imageUrls: [String] = []
    @Published var selectedPhotos: [PhotosPickerItem] = [PhotosPickerItem]()
    
    @Published var selectedMembers: [MemberEntity] = []
    @Published var entireMembers: [MemberEntity] = []
    
    @Published var noteId: String? = nil
    
    @Published var location: Location? = nil
    @Published var type: EditNoteType
    
    init(type: EditNoteType) {
        self.type = type
        super.init()
        
        // load categories, members
        self.loadCategories()
        self.loadMembers()
        
        self.loadNote()
    }
    
    
    
    
    func loadNote() {
        if let tempNote = self.temporaryNoteService.load() {
            self.type = tempNote.type
            self.noteId = tempNote.id
            self.isStar = tempNote.isStar
            self.title = tempNote.title
            self.content = tempNote.content
            self.address = tempNote.address
            self.createdAt = tempNote.createdAt
            self.category = tempNote.category ?? self.categories.first
            self.images = tempNote.images
            self.imageUrls = tempNote.imageUrls
            self.selectedPhotos = tempNote.selectedPhotos
            self.selectedMembers = tempNote.members
            self.location = tempNote.location
        } else {
            switch type {
            case .create(let address, let location):
                self.address = address
                self.location = location
                self.category = self.categories.first
                return
            case .update(let id):
                if let note = self.loadNoteWithIdUseCase.execute(id) {
                    self.noteId = note.id
                    self.isStar = note.isStar
                    self.title = note.title
                    self.content = note.content
                    self.address = note.address
                    self.createdAt = Date(timeIntervalSince1970: Double(note.createdAt))
                    self.category = note.category
                    self.images = []
                    self.imageUrls = note.imageUrls
                    self.selectedPhotos = []
                    self.selectedMembers = note.members
                    self.location = Location(latitude: note.latitude, longitude: note.longitude)
                }
            }
        }
    }
    
    func loadCategories() {
        self.categories = loadCategoriesUseCase.execute()
    }
    
    func loadMembers() {
        self.entireMembers = loadMembersUseCase.execute()
    }
    
    func deleteNote(_ onDone: @escaping (Bool)->()) {
        //TODO: delete note useCase
        guard let id = self.noteId else { return }
        onDone(self.deleteNoteUseCase.execute(id) != nil)
    }
    
    func saveNote(_ onDone: @escaping ()->()) {
        if !self.isAvailableToSave { return }
        guard let location = location, let category = self.category else { return }
        
        let currentTimeStamp = Int(Date().timeIntervalSince1970)
        for idx in self.images.indices {
            let imageName = "\(currentTimeStamp)_\(idx)"
            let _ = ImageManager.shared.saveImage(image: self.images[idx], imageName: imageName)
            self.imageUrls.append(imageName)
        }
        if let id = self.noteId {
            self.updateNoteUseCase.execute(
                id: id,
                title: self.title,
                content: self.content,
                createdAt: Int(createdAt.timeIntervalSince1970),
                imageUrls: self.imageUrls,
                category: category,
                members: self.selectedMembers,
                isStar: self.isStar,
                latitude: location.latitude,
                longitude: location.longitude,
                address: self.address
            )
        } else {
            self.saveNoteUseCase.execute(
                title: self.title,
                content: self.content,
                createdAt: Int(createdAt.timeIntervalSince1970),
                imageUrls: self.imageUrls,
                category: category,
                members: self.selectedMembers,
                isStar: self.isStar,
                latitude: location.latitude,
                longitude: location.longitude,
                address: self.address
            )
        }
        
        self.temporaryNoteService.clear()
        
        NotificationCenter.default.post(name: .changeMapStatus, object: MapStatus.normal.rawValue)
        onDone()
    }
    
    func saveTempNote(_ onDone: @escaping ()->()) {
        guard let location = self.location else { return }
        self.temporaryNoteService.save(
            type: self.type,
            id: self.noteId,
            isStar: self.isStar,
            title: self.title,
            content: self.content,
            address: self.address,
            createdAt: self.createdAt,
            category: self.category,
            images: self.images,
            imageUrls: self.imageUrls,
            selectedPhotos: self.selectedPhotos,
            members: self.selectedMembers,
            location: location
        )
        
        onDone()
    }
    
    func clearTempNote() {
        self.temporaryNoteService.clear()
    }
    
    private func checkIsAvailableToSave() {
        self.isAvailableToSave = false
        if self.address.isEmpty || self.title.isEmpty { return }
        self.isAvailableToSave = true
    }
    
    func toggleMember(_ member: MemberEntity) {
        guard let idx = self.selectedMembers.firstIndex(where: { $0.id == member.id }) else {
            self.selectedMembers.append(member)
            return
        }
        self.selectedMembers.remove(at: idx)
    }
    
    
    @MainActor
    func addImage() {
        if !selectedPhotos.isEmpty {
            Task {
                var temp: [UIImage] = [UIImage]()
                for eachItem in selectedPhotos {
                    if let imageData = try? await eachItem.loadTransferable(type: Data.self) {
                        if let image = UIImage(data: imageData) {
                            temp.append(image)
                        }
                    }
                }
                self.images = temp
            }
        } else {
            self.images.removeAll()
        }
    }
    
    @MainActor
    func deleteImage(_ idx: Int) {
        selectedPhotos.remove(at: idx)
    }
    
    @MainActor
    func deleteImageUrl(_ idx: Int) {
        guard let noteId = self.noteId else { return }
        //TODO: DB에서 이미지 url 삭제해야함
        self.deleteImageUrlUseCase.execute(noteId, url: imageUrls[idx])
        imageUrls.remove(at: idx)
    }
}
