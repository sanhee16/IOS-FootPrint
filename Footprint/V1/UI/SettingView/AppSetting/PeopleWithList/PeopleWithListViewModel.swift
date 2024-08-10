//
//  PeopleWithEditViewModel.swift
//  Footprint
//
//  Created by Studio-SJ on 2023/01/05.
//

import Foundation
import RealmSwift
import Combine
import UIKit

class PeopleWithListViewModel: BaseViewModelV1 {
    @Published var peopleWithList: [PeopleWith] = []
    private let realm: Realm
    
    override init(_ coordinator: AppCoordinatorV1) {
        self.realm = R.realm
        super.init(coordinator)
    }
    
    func onAppear() {
        self.loadAllPeopleList()
    }
    
    func onClose() {
        self.dismiss()
    }
    
    func onClickEdit(_ item: PeopleWith) {
        
    }
    
    private func loadAllPeopleList() {
        self.peopleWithList = Array(realm.objects(PeopleWith.self).filter({ item in
            item.id > 0
        }))
    }
}
