//
//  DIContainer.swift
//  Footprint
//
//  Created by sandy on 8/22/24.
//

import Foundation
import Factory

extension Container {
    var userDefaultsManager: Factory<Defaults> {
        Factory(self) { Defaults() }
    }
    
    var permissionService: Factory<PermissionService> {
        Factory(self) { PermissionService() }
    }
}

//MARK: Repository
extension Container {
    var noteRepository: Factory<NoteRepository> {
        Factory(self) { RealNoteRepository() }
    }
    
    var categoryRepository: Factory<CategoryRepository> {
        Factory(self) { CategoryRepositoryImpl() }
    }
    
    var memberRepository: Factory<MemberRepository> {
        Factory(self) { MemberRepositoryImpl() }
    }
}

//MARK: UseCase - Note
extension Container {
    var saveNoteUseCase: Factory<SaveNoteUseCase> {
        Factory(self) { SaveNoteUseCase(noteRepository: self.noteRepository()) }
    }
    
    var loadNoteUseCase: Factory<LoadNoteUseCase> {
        Factory(self) { LoadNoteUseCase(noteRepository: self.noteRepository()) }
    }
}

//MARK: UseCase - Category
extension Container {
    var saveDefaultCategoriesUseCase: Factory<SaveDefaultCategoriesUseCase> {
        Factory(self) { SaveDefaultCategoriesUseCase(categoryRepository: self.categoryRepository()) }
    }
    
    var loadCategoriesUseCase: Factory<LoadCategoriesUseCase> {
        Factory(self) { LoadCategoriesUseCase(categoryRepository: self.categoryRepository()) }
    }
    
    var saveCategoryUseCase: Factory<SaveCategoryUseCase> {
        Factory(self) { SaveCategoryUseCase(categoryRepository: self.categoryRepository()) }
    }
    
    var updateCategoryUseCase: Factory<UpdateCategoryUseCase> {
        Factory(self) { UpdateCategoryUseCase(categoryRepository: self.categoryRepository()) }
    }
    
    var deleteCategoryUseCase: Factory<DeleteCategoryUseCase> {
        Factory(self) { DeleteCategoryUseCase(categoryRepository: self.categoryRepository()) }
    }
    
    var loadCategoryUseCase: Factory<LoadCategoryUseCase> {
        Factory(self) { LoadCategoryUseCase(categoryRepository: self.categoryRepository()) }
    }
}

//MARK: UseCase - Member
extension Container {
    var saveMemberUseCase: Factory<SaveMemberUseCase> {
        Factory(self) { SaveMemberUseCase(memberRepository: self.memberRepository()) }
    }
    
    var loadMembersUseCase: Factory<LoadMembersUseCase> {
        Factory(self) { LoadMembersUseCase(memberRepository: self.memberRepository()) }
    }
    
    var deleteMemberUseCase: Factory<DeleteMemberUseCase> {
        Factory(self) { DeleteMemberUseCase(memberRepository: self.memberRepository()) }
    }
    
    var updateMemberUseCase: Factory<UpdateMemberUseCase> {
        Factory(self) { UpdateMemberUseCase(memberRepository: self.memberRepository()) }
    }
}
