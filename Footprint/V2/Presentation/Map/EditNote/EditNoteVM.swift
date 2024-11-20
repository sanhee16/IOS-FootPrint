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

class EditNoteVM: BaseViewModel {
    @Injected(\.saveNoteUseCase) var saveNoteUseCase
    @Injected(\.deleteImageUrlUseCase) var deleteImageUrlUseCase
    @Injected(\.loadCategoriesUseCase) var loadCategoriesUseCase
    @Injected(\.loadMembersUseCase) var loadMembersUseCase
    @Injected(\.permissionService) var permissionService
    @Injected(\.loadNoteUseCaseWithId) var loadNoteUseCaseWithId
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
    
    private var noteId: String? = nil
    
    private var location: Location? = nil
    
    init(note: TemporaryNote) {
        super.init()
        // load categories, members
        self.loadCategories()
        self.loadMembers()
        
        self.loadNote(note)
    }
    
    private func loadNote(_ tempNote: TemporaryNote) {
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
        
        self.noteId = tempNote.id
    }
    
    func loadCategories() {
        self.categories = loadCategoriesUseCase.execute()
        print("self.categories: \(self.categories)")
    }
    
    func loadMembers() {
        self.entireMembers = loadMembersUseCase.execute()
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
        
        self.temporaryNoteService.clear()
        
        NotificationCenter.default.post(name: .changeMapStatus, object: MapStatus.normal.rawValue)
        onDone()
    }
    
    func saveTempNote(_ onDone: @escaping ()->()) {
        guard let location = self.location else { return }
        self.temporaryNoteService.saveTempNote(
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
        
        NotificationCenter.default.post(name: .changeMapStatus, object: MapStatus.adding.rawValue)
        NotificationCenter.default.post(name: .isShowTabBar, object: false)
        
        onDone()
    }
    
    func clearFootprint() {
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
