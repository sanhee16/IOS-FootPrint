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
    case modify(id: String)
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
    @Published var members: [MemberEntity] = []
    
    private var noteId: String? = nil
    
    //    @Published var images: [UIImage] = []
    @Published var isCategoryEditMode: Bool = false
    @Published var isPeopleWithEditMode: Bool = false
    @Published var peopleWith: [PeopleWith] = []
    let type: EditNoteType
    
    private var modifyId: ObjectId? = nil
    private var location: Location? = nil
    private var placeId: String? = nil
        
    init(type: EditNoteType) {
        self.type = type
        
        super.init()
        // load categories, members
        self.loadCategories()
        self.loadMembers()
        if let tempNote = MapView2.tempNote {
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
            self.members = tempNote.members
        } else {
            switch self.type {
            case .create(let location, let address):
                self.location = location
                self.address = address
                self.category = self.categories.first
                self.members = []
            case .modify(let id):
                self.noteId = id
                self.loadNote()
            }
        }
    }
    
    private func loadNote() {
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
        self.members = note.peopleWith ?? []
    }
    
    func loadCategories() {
        self.categories = loadCategoriesUseCase.execute()
    }
    
    func loadMembers() {
        let selectedMembers = self.members.filter({ $0.isSelected })
        self.members = loadMembersUseCase.execute()
        for i in self.members.indices {
            if let memberId = self.members[i].id, selectedMembers.contains(where: { $0.id == memberId }) {
                self.members[i].isSelected = true
            }
        }
    }
    
    func saveNote(_ onDone: @escaping ()->()) {
        if !self.isAvailableToSave { return }
        guard let location = location, let category = self.category, let categoryId = category.id else { return }
        
        let memberIds: List<String> = List()
        members.filter({ $0.isSelected }).compactMap({ $0.id }).forEach { id in
            memberIds.append(id)
        }
//        var imageUrls: [String] = self.imageUrls
        let currentTimeStamp = Int(Date().timeIntervalSince1970)
        for idx in self.images.indices {
            let imageName = "\(currentTimeStamp)_\(idx)"
            let _ = ImageManager.shared.saveImage(image: self.images[idx], imageName: imageName)
            self.imageUrls.append(imageName)
        }
        
        saveNoteUseCase.execute(
            Note(
                title: self.title,
                content: self.content,
                createdAt: Int(createdAt.timeIntervalSince1970),
                imageUrls: self.imageUrls,
                categoryId: categoryId,
                peopleWithIds: self.members.compactMap({ $0.id }),
                isStar: self.isStar,
                latitude: location.latitude,
                longitude: location.longitude,
                address: self.address
            )
        )
        onDone()
    }
    
    func saveTempNote(_ onDone: @escaping ()->()) {
        MapView2.tempNote = TempNote(
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
            members: self.members
        )
        
        onDone()
    }
    
    private func checkIsAvailableToSave() {
        self.isAvailableToSave = false
        if self.address.isEmpty || self.title.isEmpty { return }
        self.isAvailableToSave = true
    }
    
    func toggleMember(_ member: MemberEntity) {
        guard let idx = self.members.firstIndex(where: { $0 == member }) else { return }
        self.members[idx].isSelected.toggle()
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
