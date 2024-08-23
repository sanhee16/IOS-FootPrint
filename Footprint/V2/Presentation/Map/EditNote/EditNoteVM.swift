//
//  EditNoteVM.swift
//  Footprint
//
//  Created by sandy on 8/10/24.
//

import Foundation
import Combine
import UIKit
import Photos
import RealmSwift
import Factory


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

   

class EditNoteVM: BaseViewModel {
    @Injected(\.saveNoteUseCase) var saveNoteUseCase
    @Injected(\.loadCategoriesUseCase) var loadCategoriesUseCase
    
    @Published var isAvailableToSave: Bool = false
    @Published var isStar: Bool = false
    @Published var title: String = "" { didSet { checkIsAvailableToSave() }}
    @Published var content: String = ""
    @Published var address: String = "" { didSet { checkIsAvailableToSave() }}
    @Published var createdAt: Date = Date()
    @Published var categories: [CategoryV2] = []
    @Published var category: CategoryV2? = nil
    
    
    
    
    
    
    @Published var images: [UIImage] = []
    @Published var isCategoryEditMode: Bool = false
    @Published var isPeopleWithEditMode: Bool = false
    @Published var peopleWith: [PeopleWith] = []
    @Published var type: EditFootprintType? = nil
    
    private var modifyId: ObjectId? = nil
    private var location: Location? = nil
    private var placeId: String? = nil
    
    var viewEventTrigger: ((EditNoteView.ViewEventTrigger) -> ())? = nil
    
    override init() {
        
        super.init()
        
        
        // loadCategories
        self.categories = loadCategoriesUseCase.execute()
        self.category = self.categories.first
    }
    
    func saveNote() {
        if !self.isAvailableToSave { return }
        guard let location = location else { return }

        saveNoteUseCase.execute(
            NoteData(
                title: self.title,
                content: self.content,
                images: List<String>(),
                latitude: location.latitude,
                longitude: location.longitude,
                tag: 0,
                peopleWithIds: List<Int>(),
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
    
    
    
    
    
    
    
    
    
    
    
    func setValue(location: Location, type: EditFootprintType, viewEventTrigger: @escaping ((EditNoteView.ViewEventTrigger) -> ())) {
        self.location = location
        self.type = type
        
        
//        if case let .modify(contents) = self.type {
//            self.createdAt = contents.createdAt
//            self.title = contents.title
//            self.content = contents.content
//            self.images = contents.images
//            self.category = contents.category
//            self.peopleWith = contents.peopleWith
//            self.modifyId = contents.id
//            self.isStar = contents.isStar
//        } else if case let .new(name, placeId, address) = self.type {
//            self.title = name ?? ""
//            self.placeId = placeId
//            self.address = address ?? ""
//            
//            let item = self.realm.object(ofType: PeopleWith.self, forPrimaryKey: 0)
//            if let item = item {
//                self.peopleWith.append(item)
//            }
//        } else {
//            let item = self.realm.object(ofType: PeopleWith.self, forPrimaryKey: 0)
//            if let item = item {
//                self.peopleWith.append(item)
//            }
//        }
        
        self.viewEventTrigger = viewEventTrigger
        
        self.isStar = EditNoteTempStorage.isStar
        self.title = EditNoteTempStorage.title
        self.content = EditNoteTempStorage.content
        self.address = EditNoteTempStorage.address
        self.createdAt = EditNoteTempStorage.createdAt
    }
    
    
    private func photoPermissionCheck(_ callback: @escaping (Bool)->()) {
        let photoAuthStatus = PHPhotoLibrary.authorizationStatus()
        switch photoAuthStatus {
        case .notDetermined:
            print("권한 승인을 아직 하지 않음")
            PHPhotoLibrary.requestAuthorization() { status in
                switch status {
                case .denied:
                    print("거부됨")
                    callback(false)
                    break
                case .authorized:
                    print("승인됨")
                    callback(true)
                    break
                default:
                    callback(false)
                    break
                }
            }
        case .restricted:
            print("권한을 부여할 수 없음")
            callback(false)
            break
        case .denied:
            print("거부됨")
            callback(false)
            break
        case .authorized:
            print("승인됨")
            callback(true)
            break
        case .limited:
            print("limited")
            callback(false)
            break
        @unknown default:
            print("unknown default")
            callback(false)
            break
        }
    }
}
