//
//  SelectFootprintsViewModel.swift
//  Footprint
//
//  Created by Studio-SJ on 2023/01/03.
//


import Foundation
import Combine
import UIKit
import RealmSwift

class SelectFootprintsViewModel: BaseViewModelV1 {
    @Published var selectedList: [FootPrint] = []
    @Published var list: [FootPrint] = []
    private let realm: Realm
    private let callback: ([FootPrint])->()
    
    init(_ coordinator: AppCoordinator, selectedList: [FootPrint], callback: @escaping ([FootPrint])->()) {
        self.realm = R.realm
        self.selectedList = selectedList
        self.callback = callback
        super.init(coordinator)
        self.loadAllItems()
    }
    
    func onAppear() {
        
    }
    
    func onClose() {
        self.dismiss()
    }
    
    func onClickComplete() {
        self.dismiss(animated: true) {[weak self] in
            guard let self = self else { return }
            self.callback(self.selectedList)
        }
    }
    
    func loadAllItems() {
        self.list = self.realm.objects(FootPrint.self)
            .filter { item in
                item.deleteTime == 0
            }
    }
    
    func onClickItem(_ item: FootPrint) {
        if let idx = self.selectedIdx(item) {
            self.selectedList.remove(at: idx)
        } else {
            self.selectedList.append(item)
        }
    }
    
    func getPeopleWiths(_ ids: [Int]) -> [PeopleWith] {
        var list: [PeopleWith] = []
        for id in ids {
            if let item = id.getPeopleWith() {
                list.append(item)
            }
        }
        return list
    }
    
    func selectedIdx(_ item: FootPrint) -> Int? {
        return self.selectedList.firstIndex(where: { listItem in
            listItem.id == item.id
        })
    }
}
