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
import SwiftUIPager
import RealmSwift
import SwiftUI
import Factory

class FootprintVM: BaseViewModel {
    @Injected(\.loadNoteUseCaseWithId) var loadNoteUseCaseWithId
    @Published var footPrints: Note? = nil
    private let realm: Realm
    private var isLoading: Bool = false
    private let id: String
    @Published var isFailToLoad: Bool = false
    
    init(_ id: String) {
        self.realm = R.realm
        self.id = id
        super.init()
        self.loadData()
    }
    
    func onAppear() {
        
    }
    
    func loadData() {
        guard let note = self.loadNoteUseCaseWithId.execute(id) else {
            self.isFailToLoad = true
            return
        }
        self.footPrints = note
    }
}
