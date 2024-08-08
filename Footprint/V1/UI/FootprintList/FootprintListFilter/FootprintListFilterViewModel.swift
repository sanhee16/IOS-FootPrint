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

typealias peopleWithItem = (item: PeopleWith, isSelected: Bool)
typealias categoryItem = (item: Category, isSelected: Bool)

class FootprintListFilterViewModel: BaseViewModel {
    @Published var peopleWithList: [peopleWithItem] = []
    @Published var categoryList: [categoryItem] = []

    private var realm: Realm
    
    override init(_ coordinator: AppCoordinator) {
        self.realm = R.realm
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
            if i.isSelected == true {
                peopleWithIds.append(i.item.id)
            }
        }
        for i in self.categoryList {
            if i.isSelected == true {
                categoryIds.append(i.item.tag)
            }
        }
        
        Defaults.isSetFilter = true
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
        
        if !Defaults.isSetFilter {
            for i in realm.objects(PeopleWith.self) {
                peopleWithList.append((item: i, isSelected: true))
            }
            for i in realm.objects(Category.self) {
                categoryList.append((item: i, isSelected: true))
            }
        } else {
            let list1 = Defaults.filterPeopleIds
            let list2 = Defaults.filterCategoryIds
            
            for i in realm.objects(PeopleWith.self) {
                if list1.contains(where: { id in
                    id == i.id
                }) {
                    peopleWithList.append((item: i, isSelected: true))
                } else {
                    peopleWithList.append((item: i, isSelected: false))
                }
            }
            for i in realm.objects(Category.self) {
                if list2.contains(where: { tag in
                    tag == i.tag
                }) {
                    categoryList.append((item: i, isSelected: true))
                } else {
                    categoryList.append((item: i, isSelected: false))
                }
            }
        }
    }
    
    func onClickCategory(_ category: Category) {
        if let idx = self.categoryList.firstIndex(where: { (item: Category, isSelected: Bool) in
            item.tag == category.tag
        }) {
            self.categoryList[idx].isSelected = !self.categoryList[idx].isSelected
        }
    }
    
    func onClickPeopleWith(_ peopleWith: PeopleWith) {
        if let idx = self.peopleWithList.firstIndex(where: { (item: PeopleWith, isSelected: Bool) in
            item.id == peopleWith.id
        }) {
            self.peopleWithList[idx].isSelected = !self.peopleWithList[idx].isSelected
        }
    }
}

