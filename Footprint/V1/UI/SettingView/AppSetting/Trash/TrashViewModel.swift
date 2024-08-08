//
//  TrashViewModel.swift
//  Footprint
//
//  Created by Studio-SJ on 2023/01/17.
//


import Foundation
import Combine
import UIKit
import RealmSwift

enum TrashStatus {
    case none
    case recovering
//    case deleting
}
typealias TrashFootprint = (item: FootPrint, isSelected: Bool, leftDays: Int)
typealias TrashTravel = (item: Travel, isSelected: Bool, leftDays: Int)
class TrashViewModel: BaseViewModel {
    @Published var trashStatus: TrashStatus = .none
    @Published var footprintItems: [TrashFootprint] = []
    @Published var travelItems: [TrashTravel] = []
    
    private let realm: Realm
    
    
    override init(_ coordinator: AppCoordinator) {
        self.realm = R.realm
        super.init(coordinator)
    }
    
    func onAppear() {
        self.loadAll()
    }
    
    func loadAll() {
        let travelList = self.realm.objects(Travel.self).filter { item in
            item.deleteTime > 0
        }
        let footprintList = self.realm.objects(FootPrint.self).filter { item in
            item.deleteTime > 0
        }
        self.footprintItems.removeAll()
        self.travelItems.removeAll()
        let today = Date()
        let todayTime = Int(today.timeIntervalSince1970)
        
        for i in travelList {
            var leftDays: Int = 0
            if let deleteDate = Calendar.current.date(byAdding: .day, value: Defaults.deleteDays, to: Date(timeIntervalSince1970: Double(i.deleteTime))) {
                let limit = Int(deleteDate.timeIntervalSince1970)
                leftDays = (limit - todayTime) / 60 / 60 / 24
            }

            self.travelItems.append((item: i, isSelected: false, leftDays: leftDays))
        }
        for i in footprintList {
            var leftDays: Int = 0
            if let deleteDate = Calendar.current.date(byAdding: .day, value: Defaults.deleteDays, to: Date(timeIntervalSince1970: Double(i.deleteTime))) {
                let limit = Int(deleteDate.timeIntervalSince1970)
                leftDays = (limit - todayTime) / 60 / 60 / 24
            }
            
            self.footprintItems.append((item: i, isSelected: false, leftDays: leftDays))
        }
    }
    
    func onClickSelectFootprint(_ item: TrashFootprint) {
        for i in footprintItems.indices {
            if footprintItems[i] == item {
                footprintItems[i].isSelected = !footprintItems[i].isSelected
                return
            }
        }
    }
    
    func onClickSelectTravel(_ item: TrashTravel) {
        for i in travelItems.indices {
            if travelItems[i] == item {
                travelItems[i].isSelected = !travelItems[i].isSelected
                return
            }
        }
    }
    
    func deleteAll() {
        self.alert(.yesOrNo, title: "alert_empty_trash".localized(), description: "alert_empty_trash_description".localized()) {[weak self] isDelete in
            guard let self = self else { return }
            if isDelete {
                var deleteTravels: [Travel] = []
                var deleteFootprints: [FootPrint] = []
                
                for i in self.travelItems {
                    deleteTravels.append(i.item)
                }
                for i in self.footprintItems {
                    deleteFootprints.append(i.item)
                }
                
                try! self.realm.write {[weak self] in
                    guard let self = self else { return }
                    for i in deleteTravels {
                        print("delete travel: \(i.title)")
                        self.realm.delete(i)
                    }
                    for i in deleteFootprints {
                        print("delete footprint: \(i.title)")
                        self.realm.delete(i)
                    }
                    self.loadAll()
                }
            } else {
                return
            }
        }
    }
    
    func cancel() {
        for i in self.travelItems.indices {
            self.travelItems[i].isSelected = false
        }
        for i in self.footprintItems.indices {
            self.footprintItems[i].isSelected = false
        }
        self.trashStatus = .none
    }
    
    func recoveryItems() {
        var recoveryTravels: [Travel] = []
        var recoveryFootprints: [FootPrint] = []
        
        for i in travelItems {
            if i.isSelected {
                recoveryTravels.append(i.item)
            }
        }
        for i in footprintItems {
            if i.isSelected {
                recoveryFootprints.append(i.item)
            }
        }
        
        try! self.realm.write {[weak self] in
            guard let self = self else { return }
            for i in recoveryTravels {
                i.deleteTime = 0
                self.realm.add(i, update: .modified)
            }
            for i in recoveryFootprints {
                i.deleteTime = 0
                self.realm.add(i, update: .modified)
            }
            self.trashStatus = .none
            self.loadAll()
        }
    }
    
    func onClose() {
        self.dismiss()
    }
}
