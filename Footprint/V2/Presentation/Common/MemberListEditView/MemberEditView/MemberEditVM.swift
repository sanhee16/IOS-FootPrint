//
//  MemberEditVM.swift
//  Footprint
//
//  Created by sandy on 8/24/24.
//

import Foundation
import Factory
import SwiftUI
import Photos
import PhotosUI
import _PhotosUI_SwiftUI

enum MemberEditType {
    case create
    case modify
    
    var title: String {
        switch self {
        case .create:
            return "사람 추가하기"
        case .modify:
            return "사람 편집하기"
        }
    }
}

class MemberEditVM: BaseViewModel {
    @Injected(\.saveMemberUseCase) var saveMemberUseCase
    @Injected(\.updateMemberUseCase) var updateMemberUseCase
    var type: MemberEditType
    
    @Published var name: String = "" { didSet { checkIsAvailableToSave() }}
    @Published var intro: String = ""
    @Published var image: UIImage? = nil
    @Published var isAvailableToSave: Bool = false
    @Published var selectedPhoto: PhotosPickerItem? = nil
    private var id: String? = nil
    private var idx: Int? = nil
    
    private var isLoading: Bool = false
    
    
    override init() {
        self.type = .create
        super.init()
    }
    
    func setMember(_ member: MemberEntity?) {
        guard let member = member else {
            self.type = .create
            self.id = nil
            self.name = ""
            self.image = nil
            self.intro = ""
            return
        }
        self.type = .modify
        self.id = member.id
        self.idx = member.idx
        self.name = member.name
        self.image = ImageManager.shared.getSavedImage(named: member.image)
        self.intro = member.intro
    }

    func saveMember(_ onDone: @escaping () -> ()) {
        if !self.isAvailableToSave { return }
        switch self.type {
        case .create:
            self.saveMemberUseCase.execute(id, name: self.name, image: self.image, intro: self.intro)
        case .modify:
            guard let id = id, let idx = idx else { return }
            self.updateMemberUseCase.execute(id, idx: idx, name: self.name, image: self.image, intro: self.intro)
        }
        onDone()
    }
    
    private func checkIsAvailableToSave() {
        self.isAvailableToSave = false
        if self.name.isEmpty { return }
        self.isAvailableToSave = true
    }
    
    @MainActor
    func selectImage() {
        guard let selectedPhoto = selectedPhoto else {
            self.image = nil
            return
        }
        Task {
            if let imageData = try? await selectedPhoto.loadTransferable(type: Data.self) {
                if let image = UIImage(data: imageData) {
                    self.image = image
                }
            }
        }
    }
    
    @MainActor
    func deleteImage(_ idx: Int) {
        selectedPhoto = nil
    }
}
