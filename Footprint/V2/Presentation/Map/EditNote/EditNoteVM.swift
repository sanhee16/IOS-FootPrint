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

public enum EditNoteType {
    case create(location: Location, address: String)
    case modify(id: String, address: String)
}

class EditNoteVM: BaseViewModel {
    @Injected(\.saveNoteUseCase) var saveNoteUseCase
    @Injected(\.deleteImageUrlUseCase) var deleteImageUrlUseCase
    @Injected(\.loadCategoriesUseCase) var loadCategoriesUseCase
    @Injected(\.loadMembersUseCase) var loadMembersUseCase
    @Injected(\.permissionService) var permissionService
    @Injected(\.loadNoteUseCaseWithId) var loadNoteUseCaseWithId
    
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
    
    private var noteId: String? = nil
    let type: EditNoteType
    
    private var location: Location? = nil
    
    init(type: EditNoteType) {
        self.type = type
        
        super.init()
        // load categories, members
        self.loadCategories()
        self.loadMembers()
        if let tempNote = MapStatusVM.tempNote {
            self.noteId = tempNote.id
            self.isStar = tempNote.isStar
            self.title = tempNote.title
            self.content = tempNote.content
            self.address = tempNote.address
            self.createdAt = tempNote.createdAt
            self.categories = tempNote.categories
            self.category = tempNote.category
            self.images = tempNote.images
            self.imageUrls = tempNote.imageUrls
            self.selectedPhotos = tempNote.selectedPhotos
            self.selectedMembers = tempNote.members
            self.location = tempNote.location
        } else {
            switch self.type {
            case .create(let location, let address):
                self.location = location
                self.address = address
                self.category = self.categories.first
                self.selectedMembers = []
            case .modify(let id, let address):
                self.noteId = id
                self.address = address
                self.loadExistedNote()
            }
        }
    }
    
    private func loadExistedNote() {
        guard let noteId = self.noteId, let note = self.loadNoteUseCaseWithId.execute(noteId) else { return }
        self.isStar = note.isStar
        self.title = note.title
        self.content = note.content
        self.address = note.address
        self.createdAt = Date(timeIntervalSince1970: Double(note.createdAt))
        self.category = note.category
        self.imageUrls = note.imageUrls
        self.location = Location(latitude: note.latitude, longitude: note.longitude)
        self.selectedPhotos = []
        self.selectedMembers = note.peopleWith ?? []
    }
    
    func loadCategories() {
        self.categories = loadCategoriesUseCase.execute()
    }
    
    func loadMembers() {
        self.entireMembers = loadMembersUseCase.execute()
    }
    
    func saveNote(_ onDone: @escaping ()->()) {
        if !self.isAvailableToSave { return }
        guard let location = location, let category = self.category else { return }
        
        //        var imageUrls: [String] = self.imageUrls
        let currentTimeStamp = Int(Date().timeIntervalSince1970)
        for idx in self.images.indices {
            let imageName = "\(currentTimeStamp)_\(idx)"
            let _ = ImageManager.shared.saveImage(image: self.images[idx], imageName: imageName)
            self.imageUrls.append(imageName)
        }
        
        saveNoteUseCase.execute(
            id: self.noteId,
            title: self.title,
            content: self.content,
            createdAt: Int(createdAt.timeIntervalSince1970),
            imageUrls: self.imageUrls,
            categoryId: category.id,
            peopleWithIds: self.selectedMembers.compactMap({ $0.id }),
            isStar: self.isStar,
            latitude: location.latitude,
            longitude: location.longitude,
            address: self.address
        )
        NotificationCenter.default.post(name: .changeMapStatus, object: MapStatus.normal.rawValue)
        onDone()
    }
    
    func saveTempNote(_ onDone: @escaping ()->()) {
        guard let location = self.location else { return }
        MapStatusVM.tempNote = TempNote(
            id: self.noteId,
            isStar: self.isStar,
            title: self.title,
            content: self.content,
            address: self.address,
            createdAt: self.createdAt,
            categories: self.categories,
            category: self.category,
            images: self.images,
            imageUrls: self.imageUrls,
            selectedPhotos: self.selectedPhotos,
            members: self.selectedMembers,
            location: location
        )
        
        NotificationCenter.default.post(name: .changeMapStatus, object: MapStatus.adding.rawValue)
        NotificationCenter.default.post(name: .isShowTabBar, object: false)
        
        onDone()
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
    
    //    func checkPhotoPermsission(_ onDone: @escaping (Bool) -> ()) {
    //        self.permissionService.photoPermissionCheck { isAllow in
    //            onDone(isAllow)
    //        }
    //    }
}
