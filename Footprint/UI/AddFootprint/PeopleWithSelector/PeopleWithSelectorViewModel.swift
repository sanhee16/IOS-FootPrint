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
    //    @Published var serachText: String = ""
    //    private var peopleWithList: [PeopleWith] = []
    @Published var peopleWithShowList: [PeopleWith] = []
    @Published var peopleWithSelectList: [PeopleWith] = []
    //    @Published var isMatching: Bool = false
    private let realm: Realm
    private var originalList: [PeopleWith]
    private let callback: ([PeopleWith])->()
    
    init(_ coordinator: AppCoordinator, peopleWith: [PeopleWith], callback: @escaping ([PeopleWith])->()) {
        self.realm = try! Realm()
        self.callback = callback
        self.originalList = peopleWith
        super.init(coordinator)
        
        for item in peopleWith {
            self.peopleWithSelectList.append(item)
        }
    }
    
    func onAppear() {
        loadAllPeopleList()
    }
    
    func onClose() {
        self.dismiss(animated: false) {[weak self] in
            guard let self = self else { return }
            self.callback(self.originalList)
        }
    }
    
    private func loadAllPeopleList(_ deleteId: Int? = nil) {
        peopleWithShowList = Array(realm.objects(PeopleWith.self)
            .filter({ item in
                item.id > 0
            }).sorted(by: { lhs, rhs in
                lhs.name < rhs.name
            })
        )
        
        if let deleteId = deleteId {
            if let idx = peopleWithSelectList.firstIndex(where: { item in
                item.id == deleteId
            }) {
                peopleWithSelectList.remove(at: idx)
            }
            if let idx = originalList.firstIndex(where: { item in
                item.id == deleteId
            }) {
                originalList.remove(at: idx)
            }
            
            let deleteList = Array(self.realm.objects(FootPrint.self)
                .filter { footprint in
                    footprint.peopleWithIds.contains { id in
                        id == deleteId
                    }
                })
            for item in deleteList {
                try! self.realm.write({ [weak self] in
                    guard let self = self else { return }
                    if let idx = item.peopleWithIds.firstIndex(of: deleteId) {
                        item.peopleWithIds.remove(at: idx)
                        self.realm.add(item, update: .modified)
                    }
                })
            }
        }
    }
    
    func isSelectedPeople(_ item: PeopleWith) -> Bool {
        return self.peopleWithSelectList.contains { peopleWith in
            peopleWith.id == item.id
        }
    }
    
    private func makeCopyPeopleWith(_ item: PeopleWith) -> PeopleWith {
        return PeopleWith(id: item.id, name: item.name, image: item.image, intro: item.intro)
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
                listItem.id == item.id
            }
        } else {
            self.peopleWithSelectList.append(makeCopyPeopleWith(item))
        }
    }
    
    func onClickAddPeople() {
        self.coordinator?.presentPeopleEditView(PeopleEditStruct(.new, name: ""), callback: { [weak self] deleteId in
            self?.loadAllPeopleList(deleteId)
        })
    }
    
    func onClickEditPeople(_ item: PeopleWith) {
        self.coordinator?.presentPeopleEditView(PeopleEditStruct(.modify, item: item), callback: { [weak self] deleteId in
            self?.loadAllPeopleList(deleteId)
        })
    }
}
