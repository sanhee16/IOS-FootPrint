//
//  FootprintListFilterViewModel.swift
//  Footprint
//
//  Created by sandy on 2022/12/18.
//

import Foundation
import Combine
import RealmSwift
import UIKit

class FootprintListFilterViewModel: BaseViewModel {
    @Published var peopleWithList: [PeopleWith : Bool] = [:]
    @Published var categoryList: [Category : Bool] = [:]
//    @Published var selectedPeopleWithList: [PeopleWith] = []
//    @Published var selectedCategoryList: [Category] = []
    private var realm: Realm
    
    override init(_ coordinator: AppCoordinator) {
        self.realm = try! Realm()
        super.init(coordinator)
        loadFiltersInfo()
    }
    
    func onAppear() {
        
    }
    
    func onClose() {
        self.dismiss()
    }
    
    func onClickSave() {
        var peopleWithIds: [Int] = []
        var categoryIds: [Int] = []
        for i in self.peopleWithList {
            if i.value == true {
                peopleWithIds.append(i.key.id)
            }
        }
        for i in self.categoryList {
            if i.value == true {
                categoryIds.append(i.key.tag)
            }
        }
        
        Defaults.filterCategoryIds = categoryIds
        Defaults.filterPeopleIds = peopleWithIds
        self.dismiss()
    }
    
    func onClickClear() {
        self.loadFiltersInfo()
    }
    
    func loadFiltersInfo() {
        peopleWithList.removeAll()
        categoryList.removeAll()
        
        let list1 = Defaults.filterPeopleIds
        let list2 = Defaults.filterCategoryIds
        
        for i in realm.objects(PeopleWith.self) {
            if list1.contains(where: { id in
                id == i.id
            }) {
                peopleWithList[i] = true
            } else {
                peopleWithList[i] = false
            }
        }
        for i in realm.objects(Category.self) {
            if list2.contains(where: { tag in
                tag == i.tag
            }) {
                categoryList[i] = true
            } else {
                categoryList[i] = false
            }
        }
    }
    
    func onClickCategory(_ item: Category) {
        guard let value = self.categoryList[item] else { return }
        self.categoryList[item] = !value
    }
    
    func onClickPeopleWith(_ item: PeopleWith) {
        guard let value = self.peopleWithList[item] else { return }
        self.peopleWithList[item] = !value
    }
}

