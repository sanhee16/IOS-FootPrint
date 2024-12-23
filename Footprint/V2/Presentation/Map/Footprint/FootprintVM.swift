//
//  FootprintVM.swift
//  Footprint
//
//  Created by sandy on 8/10/24.
//

import Foundation
import Combine
import UIKit
import SwiftUI
import SwiftUIPullToRefresh
import Factory

class FootprintVM: BaseViewModel {
    @Injected(\.loadNoteWithIdUseCase) var loadNoteWithIdUseCase
    @Injected(\.loadNoteWithAddressUseCase) var loadNoteWithAddressUseCase
    @Injected(\.toogleStarUseCase) var toogleStarUseCase
    
    var footPrint: NoteEntity? = nil
    private var isLoading: Bool = false
    var id: String? = nil
    @Published var isFailToLoad: Bool = false
    @Published var isStar: Bool = false
    @Published var isHasMore: Bool = false
    
    override init() {
        super.init()
    }
    
    func onAppear() {
        
    }
    
    func updateId(_ id: String) {
        self.id = id
        self.loadData()
    }
    
    func loadData() {
        guard let id = id, let note = self.loadNoteWithIdUseCase.execute(id) else {
            self.isFailToLoad = true
            return
        }
        self.footPrint = note
        self.isStar = self.footPrint?.isStar ?? false
        self.isHasMore = self.loadNoteWithAddressUseCase.execute(note.address, type: .latest).count > 0
        self.objectWillChange.send()
    }

    func onToggleStar() {
        guard let id = id else { return }
        self.isStar = self.toogleStarUseCase.execute(id)
    }
}
