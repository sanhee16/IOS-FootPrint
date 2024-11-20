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
    
    var temporaryNoteService: Factory<TemporaryNoteService> {
        Factory(self) { TemporaryNoteService(loadNoteUseCaseWithId: self.loadNoteUseCaseWithId()) }.singleton
    }
}

//MARK: Repository
extension Container {
    var noteRepository: Factory<NoteRepository> {
        Factory(self) { NoteRepositoryImpl() }
    }
    
    var categoryRepository: Factory<CategoryRepository> {
        Factory(self) { CategoryRepositoryImpl() }
    }
    
    var memberRepository: Factory<MemberRepository> {
        Factory(self) { MemberRepositoryImpl() }
    }
    
    var settingRepository: Factory<SettingRepository> {
        Factory(self) { SettingRepositoryImpl(userDefaultsManager: self.userDefaultsManager()) }
    }
    
    var tripIconRepository: Factory<TripIconRepository> {
        Factory(self) { TripIconRepositoryImpl() }
    }
    
    var tripRepository: Factory<TripRepository> {
        Factory(self) { TripRepositoryImpl() }
    }
}

//MARK: UseCase - Note
extension Container {
    var saveNoteUseCase: Factory<SaveNoteUseCase> {
        Factory(self) { SaveNoteUseCase(noteRepository: self.noteRepository()) }
    }
    
    var loadAllNoteUseCase: Factory<LoadAllNoteUseCase> {
        Factory(self) {
            LoadAllNoteUseCase(
                noteRepository: self.noteRepository(),
                categoryRepository: self.categoryRepository(),
                memberRepository: self.memberRepository()
            )
        }
    }
    
    var loadNoteUseCaseWithId: Factory<LoadNoteUseCaseWithId> {
        Factory(self) {
            LoadNoteUseCaseWithId(
                noteRepository: self.noteRepository(),
                categoryRepository: self.categoryRepository(),
                memberRepository: self.memberRepository()
            )
        }
    }
    
    var loadNotesUseCaseWithAddress: Factory<LoadNotesUseCaseWithAddress> {
        Factory(self) {
            LoadNotesUseCaseWithAddress(
                noteRepository: self.noteRepository(),
                categoryRepository: self.categoryRepository(),
                memberRepository: self.memberRepository()
            )
        }
    }
    
    var toogleStarUseCase: Factory<ToogleStarUseCase> {
        Factory(self) { ToogleStarUseCase(noteRepository: self.noteRepository()) }
    }
    
    var deleteImageUrlUseCase: Factory<DeleteImageUrlUseCase> {
        Factory(self) { DeleteImageUrlUseCase(noteRepository: self.noteRepository()) }
    }
    
    var updateNoteUseCase: Factory<UpdateNoteUseCase> {
        Factory(self) { UpdateNoteUseCase(noteRepository: self.noteRepository()) }
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
        Factory(self) { DeleteCategoryUseCase(categoryRepository: self.categoryRepository(), noteRepository: self.noteRepository()) }
    }
    
    var loadCategoryUseCase: Factory<LoadCategoryUseCase> {
        Factory(self) { LoadCategoryUseCase(categoryRepository: self.categoryRepository()) }
    }
    
    var updateCategoryOrderUseCase: Factory<UpdateCategoryOrderUseCase> {
        Factory(self) { UpdateCategoryOrderUseCase(categoryRepository: self.categoryRepository()) }
    }
    
    var getNoteCountUseCase: Factory<GetNoteCountUseCase> {
        Factory(self) { GetNoteCountUseCase(noteRepository: self.noteRepository()) }
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
    
    var updateMemberOrderUseCase: Factory<UpdateMemberOrderUseCase> {
        Factory(self) { UpdateMemberOrderUseCase(memberRepository: self.memberRepository()) }
    }
}

//MARK: UseCase - Setting
extension Container {
    var updateIsShowMarkerUseCase: Factory<UpdateIsShowMarkerUseCase> {
        Factory(self) { UpdateIsShowMarkerUseCase(settingRepository: self.settingRepository()) }
    }
    
    var getIsShowMarkerUseCase: Factory<GetIsShowMarkerUseCase> {
        Factory(self) { GetIsShowMarkerUseCase(settingRepository: self.settingRepository()) }
    }
    
    var getTripSortTypeUseCase: Factory<GetTripSortTypeUseCase> {
        Factory(self) { GetTripSortTypeUseCase(settingRepository: self.settingRepository()) }
    }
    
    var updateTripSortTypeUseCase: Factory<UpdateTripSortTypeUseCase> {
        Factory(self) { UpdateTripSortTypeUseCase(settingRepository: self.settingRepository()) }
    }
    
    var getFootprintSortTypeUseCase: Factory<GetFootprintSortTypeUseCase> {
        Factory(self) { GetFootprintSortTypeUseCase(settingRepository: self.settingRepository()) }
    }
    
    var updateFootprintSortTypeUseCase: Factory<UpdateFootprintSortTypeUseCase> {
        Factory(self) { UpdateFootprintSortTypeUseCase(settingRepository: self.settingRepository()) }
    }
}

//MARK: UseCase - TripIcon
extension Container {
    var saveTripIconUseCase: Factory<SaveTripIconUseCase> {
        Factory(self) { SaveTripIconUseCase(tripIconRepository: self.tripIconRepository()) }
    }
    
    var saveDefaultTripIconUseCase: Factory<SaveDefaultTripIconUseCase> {
        Factory(self) { SaveDefaultTripIconUseCase(tripIconRepository: self.tripIconRepository()) }
    }
    
    var loadTripIconsUseCase: Factory<LoadTripIconsUseCase> {
        Factory(self) { LoadTripIconsUseCase(tripIconRepository: self.tripIconRepository()) }
    }
}

//MARK: UseCase - Trip
extension Container {
    var loadTripsUseCase: Factory<LoadTripsUseCase> {
        Factory(self) {
            LoadTripsUseCase(
                tripRepository: self.tripRepository(),
                tripIconRepository: self.tripIconRepository(),
                noteRepository: self.noteRepository()
            )
        }
    }
    
    var loadTripUseCase: Factory<LoadTripUseCase> {
        Factory(self) {
            LoadTripUseCase(
                tripRepository: self.tripRepository(),
                tripIconRepository: self.tripIconRepository(),
                noteRepository: self.noteRepository()
            )
        }
    }
    
    var saveTripUseCase: Factory<SaveTripUseCase> {
        Factory(self) { SaveTripUseCase(tripRepository: self.tripRepository()) }
    }
    
    var updateTripUseCase: Factory<UpdateTripUseCase> {
        Factory(self) { UpdateTripUseCase(tripRepository: self.tripRepository()) }
    }
    
    var loadFootprintsUseCase: Factory<LoadFootprintsUseCase> {
        Factory(self) { LoadFootprintsUseCase(noteRepository: self.noteRepository()) }
    }
    
    var deleteTripUseCase: Factory<DeleteTripUseCase> {
        Factory(self) { DeleteTripUseCase(tripRepository: self.tripRepository()) }
    }
}
