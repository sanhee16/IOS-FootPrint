//
//  PeopleWithSelectorViewModel.swift
//  Footprint
//
//  Created by sandy on 2022/12/11.
//

import Foundation
import Combine
import UIKit
import RealmSwift

class PeopleWithSelectorViewModel: BaseViewModel {
    @Published var serachText: String = ""
    private var peopleWithList: [PeopleWith] = []
    @Published var peopleWithShowList: [PeopleWith] = []
    @Published var peopleWithSelectList: [PeopleWith] = []
    @Published var isMatching: Bool = false
    private let realm: Realm
    private let callback: ([PeopleWith])->()
    
    init(_ coordinator: AppCoordinator, callback: @escaping ([PeopleWith])->()) {
        self.realm = try! Realm()
        self.callback = callback
        super.init(coordinator)
    }
    
    func onAppear() {
        loadAllPeopleList()
    }
    
    func onClose() {
        self.dismiss(animated: false)
    }
    
    private func loadAllPeopleList() {
        peopleWithList = Array(realm.objects(PeopleWith.self))
        peopleWithShowList = peopleWithList
        self.isMatching = !self.peopleWithList.filter {item in
            item.name == self.serachText
        }.isEmpty
    }
    
    func enterSearchText() {
        let text = self.serachText
        print("self.serachText: \(self.serachText)")
        if text.isEmpty {
            self.peopleWithShowList = self.peopleWithList
        } else {
            self.peopleWithShowList = self.peopleWithList.filter { item in
                item.name.contains(text)
            }
            self.isMatching = !self.peopleWithList.filter { item in
                item.name == text
            }.isEmpty
        }
    }
    
    func isSelectedPeople(_ item: PeopleWith) -> Bool {
        return self.peopleWithSelectList.contains(item)
    }
    
    func onFinishSelect() {
        self.dismiss(animated: false) {[weak self] in
            guard let self = self else { return }
            self.callback(self.peopleWithSelectList)
        }
    }
    
    func onClickPeopleItem(_ item: PeopleWith) {
        if isSelectedPeople(item) {
            self.peopleWithSelectList.removeAll { listItem in
                listItem.name == item.name
            }
        } else {
            self.peopleWithSelectList.append(item)
        }
    }
    
    func onClickAddPeople() {
        if serachText.isEmpty || isMatching {
            return
        }
        self.coordinator?.presentPeopleEditView(PeopleEditStruct(.new, name: self.serachText)) {[weak self] in
            self?.loadAllPeopleList()
        }
    }
    
    func onClickEditPeople(_ item: PeopleWith) {
        self.coordinator?.presentPeopleEditView(PeopleEditStruct(.modify, item: item)) {[weak self] in
            self?.loadAllPeopleList()
        }
    }
}
