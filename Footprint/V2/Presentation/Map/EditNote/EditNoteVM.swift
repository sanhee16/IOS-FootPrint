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

public enum EditFootprintType {
    case new(name: String?, placeId: String?, address: String?)
    case modify(content: FootprintContents)
}

public struct FootprintContents {
    var title: String
    var content: String
    var createdAt: Date
    var images: [UIImage]
    var category: Category
    var peopleWith: [PeopleWith]
    var id: ObjectId
    var isStar: Bool
}



public enum EditNoteType {
    case create
    case modify
}


class EditNoteVM: BaseViewModel {
    @Injected(\.saveNoteUseCase) var saveNoteUseCase
    @Injected(\.loadCategoriesUseCase) var loadCategoriesUseCase
    @Injected(\.loadMembersUseCase) var loadMembersUseCase
    @Injected(\.permissionService) var permissionService
    
    @Published var isAvailableToSave: Bool = false
    @Published var isStar: Bool = false
    @Published var title: String = "" { didSet { checkIsAvailableToSave() }}
    @Published var content: String = ""
    @Published var address: String = "" { didSet { checkIsAvailableToSave() }}
    @Published var createdAt: Date = Date()
    @Published var categories: [CategoryEntity] = []
    @Published var category: CategoryEntity? = nil
    @Published var images: [UIImage] = [UIImage]()
    @Published var selectedPhotos: [PhotosPickerItem] = [PhotosPickerItem]()
    @Published var selectMembers: [MemberEntity] = []
    @Published var members: [MemberEntity] = []
    
    private var noteId: String? = nil
    
    
    //    @Published var images: [UIImage] = []
    @Published var isCategoryEditMode: Bool = false
    @Published var isPeopleWithEditMode: Bool = false
    @Published var peopleWith: [PeopleWith] = []
    @Published var type: EditNoteType? = nil
    
    private var modifyId: ObjectId? = nil
    private var location: Location? = nil
    private var placeId: String? = nil
    
    var viewEventTrigger: ((EditNoteView.ViewEventTrigger) -> ())? = nil
    
    override init() {
        
        super.init()
        
        
        // loadCategories
        self.loadCategories()
        self.category = self.categories.first
        self.loadMembers()
        self.selectMembers = []
    }
    
    func loadCategories() {
        self.categories = loadCategoriesUseCase.execute()
    }
    
    func loadMembers() {
        self.members = loadMembersUseCase.execute()
    }
    
    func saveNote() {
        if !self.isAvailableToSave { return }
        guard let location = location, let categoryId = self.category?.id else { return }
        
        var memberIds: List<String> = List()
        selectMembers.compactMap({ $0.id }).forEach { id in
            memberIds.append(id)
        }
        
        saveNoteUseCase.execute(
            NoteData(
                title: self.title,
                content: self.content,
                images: List<String>(),
                createdAt: Int(Date().timeIntervalSince1970),
                latitude: location.latitude,
                longitude: location.longitude,
                peopleWithIds: memberIds,
                categoryId: categoryId,
                isStar: self.isStar
            ))
        EditNoteTempStorage.clear()
        viewEventTrigger?(.pop)
    }
    
    private func checkIsAvailableToSave() {
        self.isAvailableToSave = false
        if self.address.isEmpty || self.title.isEmpty { return }
        self.isAvailableToSave = true
    }
    
    func setValue(location: Location, type: EditNoteType, viewEventTrigger: @escaping ((EditNoteView.ViewEventTrigger) -> ())) {
        self.location = location
        self.type = type
        
        self.viewEventTrigger = viewEventTrigger

        self.isStar = EditNoteTempStorage.isStar
        self.title = EditNoteTempStorage.title
        self.content = EditNoteTempStorage.content
        self.address = EditNoteTempStorage.address
        self.createdAt = EditNoteTempStorage.createdAt
        self.category = EditNoteTempStorage.category ?? self.categories.first
    }
    
    func saveTempStorage() {
        EditNoteTempStorage.save(
            title: self.title,
            isStar: self.isStar,
            content: self.content,
            address: self.address,
            createdAt: self.createdAt,
            category: self.category
        )
    }
    
    
    func toggleMember(_ member: MemberEntity) {
        if let idx = self.selectMembers.firstIndex(where: { $0 == member }) {
            self.selectMembers.remove(at: idx)
        } else {
            self.selectMembers.append(member)
        }
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
    
//    func checkPhotoPermsission(_ onDone: @escaping (Bool) -> ()) {
//        self.permissionService.photoPermissionCheck { isAllow in
//            onDone(isAllow)
//        }
//    }
}
