//
//  FootprintListVMV2.swift
//  Footprint
//
//  Created by sandy on 11/18/24.
//

import Combine
import Factory

enum FootprintSortType: Int {
    case latest = 0 // 최신순
    case earliest // 오래된순
    
    var text: String {
        switch self {
        case .latest:
            return "최신순"
        case .earliest:
            return "오래된순"
        }
    }
}

class FootprintListVMV2: ObservableObject {
    @Injected(\.loadAllNoteUseCase) var loadAllNoteUseCase
    @Injected(\.getFootprintSortTypeUseCase) var getFootprintSortTypeUseCase
    @Injected(\.updateFootprintSortTypeUseCase) var updateFootprintSortTypeUseCase
    @Injected(\.temporaryNoteService) var temporaryNoteService
    
    @Published var notes: [Note] = []
    let sortTypes: [FootprintSortType] = [.latest, .earliest]
    @Published var sortType: FootprintSortType = .latest
    
    init() {
        self.sortType = self.getFootprintSortTypeUseCase.execute()
    }
    
    func loadData() {
        self.notes = self.loadAllNoteUseCase.execute(self.sortType)
    }
    
    func onSelectSortType(_ sortType: FootprintSortType, onDone: @escaping ()->()) {
        self.sortType = self.updateFootprintSortTypeUseCase.execute(sortType)
        loadData()
        onDone()
    }
    
    func loadTempFootprint(_ id: String) -> TemporaryNote? {
        self.temporaryNoteService.loadTempNote(id)
    }
    
    func clearFootprint() {
        self.temporaryNoteService.clear()
    }
}
