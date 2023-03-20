//
//  EditTravelViewModel.swift
//  Footprint
//
//  Created by Studio-SJ on 2022/12/27.
//

import Foundation
import Combine
import UIKit
import RealmSwift
import SwiftUI

enum EditTravelType {
    case create
    case edit(item: Travel)
}

class EditTravelViewModel: BaseViewModel {
    private let realm: Realm
    @Published var isStar: Bool = false
    @Published var title: String = ""
    @Published var intro: String = ""
    @Published var footprints: [FootPrint] = []
    @Published var allFootprints: [FootPrint] = []
    @Published var color: Color = Color.white
    @Published var draggedItem: FootPrint? = nil
    @Published var fromDate: Date = Date()
    @Published var toDate: Date = Date()
    private var originalItem: Travel = Travel(footprints: List(), title: "", intro: "", color: "#FFFFFF", fromDate: Date(), toDate: Date(), isStar: false)
    let type: EditTravelType
    
    init(_ coordinator: AppCoordinator, type: EditTravelType) {
        self.realm = try! Realm()
        self.type = type
        super.init(coordinator)
        if case let .edit(travel) = self.type {
            self.originalItem = travel
            self.title = travel.title
            self.intro = travel.intro
            self.footprints = Array(travel.footprints)
            self.color = Color(hex: travel.color)
            self.fromDate = Date(timeIntervalSince1970: Double(travel.fromDate))
            self.toDate = Date(timeIntervalSince1970: Double(travel.toDate))
        } else if case .create = self.type {
            self.color = self.randomColor()
        }
        self.objectWillChange.send()
    }
    
    func onAppear() {
        
    }
    
    func onClose() {
        var isChanged: Bool = true
        if originalItem.title == self.title, originalItem.color == self.color.toTravelBackground(), originalItem.intro == self.intro, Array(originalItem.footprints) == self.footprints {
            isChanged = false
        }
        if isChanged {
            self.alert(.yesOrNo, title: "저장하지 않고 나가시겠습니까?") {[weak self] isClose in
                if isClose {
                    self?.dismiss()
                }
                return
            }
        } else {
            self.dismiss()
        }
    }
    
    func loadAllFootprints() {
        self.allFootprints = Array(self.realm.objects(FootPrint.self))
    }
    
    private func randomColor() -> Color {
        Color(
            red: .random(in: 0...1),
            green: .random(in: 0...1),
            blue: .random(in: 0...1),
            opacity: 0.5
        )
    }

    
//    func onClickAdd() {
//        self.startProgress()
//        try! self.realm.write {[weak self] in
//            guard let self = self else { return }
//            let list = RealmSwift.List<FootPrint>()
//            list.append(objectsIn: self.footprints)
//            let item = Travel(footprints: list, title: self.title, intro: self.intro, color: color.toTravelBackground() ?? "#FFFFFF", fromDate: self.fromDate, toDate: self.toDate)
//            self.realm.add(item)
//            self.stopProgress()
//            self.dismiss()
//        }
//    }
    
    func onClickDeleteFootprint(_ item: FootPrint) {
        guard let idx = self.footprints.firstIndex(where: { listItem in
            listItem.id == item.id
        }) else { return }
        _ = withAnimation {[weak self] in
            self?.footprints.remove(at: idx)
        }
    }
    
    func onClickSave() {
//        if self.title.isEmpty {
//            self.alert(.ok, title: "제목을 입력해주세요.")
//            return
//        }
//        if self.footprints.isEmpty {
//            self.alert(.ok, title: "노트를 선택해주세요.")
//            return
//        }
        
        if case .create = type {
            try! self.realm.write {[weak self] in
                guard let self = self else { return }
                self.startProgress()
                let saveFootprints: RealmSwift.List<FootPrint> = RealmSwift.List<FootPrint>()
                for item in self.footprints {
                    saveFootprints.append(item)
                }

                let item: Travel = Travel(footprints: saveFootprints, title: self.title, intro: self.intro, color: color.toTravelBackground() ?? "#FFFFFF", fromDate: self.fromDate, toDate: self.toDate, isStar: self.isStar)
                self.realm.add(item)
                self.stopProgress()
                self.dismiss()
            }
        } else if case let .edit(travel) = type {
            try! self.realm.write {[weak self] in
                guard let self = self else { return }
                self.startProgress()
                let saveFootprints: RealmSwift.List<FootPrint> = RealmSwift.List<FootPrint>()
                for item in self.footprints {
                    saveFootprints.append(item)
                }

                let item: Travel = Travel(id: travel.id, footprints: saveFootprints, title: self.title, intro: self.intro, color: color.toTravelBackground() ?? "#FFFFFF", fromDate: self.fromDate, toDate: self.toDate, isStar: self.isStar)
                self.realm.add(item, update: .modified)
                self.stopProgress()
                self.dismiss()
            }
        }
    }
    
    func onClickAddFootprints() {
        self.coordinator?.presentSelectFootprintsView(selectedList: self.footprints, callback: { res in
            print(res)
            self.footprints = res
        })
    }
}
