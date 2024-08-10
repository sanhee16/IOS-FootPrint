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

class PeopleWithSelectorViewModel: BaseViewModelV1 {
    @Published var peopleWithShowList: [PeopleWith] = []
    @Published var peopleWithSelectList: [PeopleWith] = []
    let type: PeopleWithEditType
    private let realm: Realm
    private var originalList: [PeopleWith] = []
    
    init(_ coordinator: AppCoordinatorV1, type: PeopleWithEditType) {
        self.realm = R.realm
        self.type = type
        super.init(coordinator)
        
        if case let .select(list, _) = self.type {
            self.originalList = list
        }
        for item in self.originalList {
            self.peopleWithSelectList.append(item)
        }
        self.objectWillChange.send()
    }
    
    func onAppear() {
        loadAllPeopleList()
    }
    
    func onClose() {
        if case let .select(_, callback) = type {
            self.dismiss(animated: false) {[weak self] in
                guard let self = self else { return }
                callback(self.originalList)
            }
        } else if case .edit = type {
            self.dismiss(animated: false)
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
        if case let .select(_, callback) = type {
            self.dismiss(animated: false) {[weak self] in
                guard let self = self else { return }
                callback(self.peopleWithSelectList)
            }
        } else if case .edit = type {
            self.dismiss(animated: false)
        }
    }
    
    func onClickPeopleItem(_ item: PeopleWith) {
        if case .select(_, _) = type {
            if isSelectedPeople(item) {
                self.peopleWithSelectList.removeAll { listItem in
                    listItem.id == item.id
                }
            } else {
                self.peopleWithSelectList.append(makeCopyPeopleWith(item))
            }
        } else if case .edit = type {
            self.coordinator?.presentPeopleEditView(PeopleEditStruct(.modify, item: item), callback: { [weak self] deleteId in
                self?.loadAllPeopleList(deleteId)
            })
        }
    }
    
    func onClickAddPeople() {
        self.coordinator?.presentPeopleEditView(PeopleEditStruct(.new, name: ""), callback: { [weak self] deleteId in
            self?.loadAllPeopleList(deleteId)
        })
    }
}
