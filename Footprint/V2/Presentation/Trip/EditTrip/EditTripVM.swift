//
//  EditTripVM.swift
//  Footprint
//
//  Created by sandy on 11/14/24.
//

import Combine
import Factory
import Foundation
import SwiftUI

public enum EditTripType {
    case create
    case modify(id: String)
}

public enum PeriodStatus {
    case selecting
    case selected
    case unSelected
    
    var textColor: Color {
        switch self {
        case .selecting:
            return .btn_text_primary_press
        case .selected:
            return .cont_gray_default
        case .unSelected:
            return .cont_gray_low
        }
    }
}

class EditTripVM: ObservableObject {
    private let type: EditTripType
    @Injected(\.saveTripUseCase) var saveTripUseCase
    @Injected(\.updateTripUseCase) var updateTripUseCase
    @Injected(\.loadTripUseCase) var loadTripUseCase
    @Injected(\.loadTripIconsUseCase) var loadTripIconsUseCase
    @Injected(\.loadFootprintsUseCase) var loadFootprintsUseCase
    
    @Published var isAvailableToSave: Bool = false
    
    @Published var title: String = "" { didSet { self.checkIsAvailableToSave() }}
    @Published var content: String = ""
    @Published var startAt: Date = Date() { didSet { self.checkIsAvailableToSave() }}
    @Published var endAt: Date = Date() { didSet { self.checkIsAvailableToSave() }}
    @Published var icon: TripIconEntity? = nil { didSet { self.checkIsAvailableToSave() }}
    @Published var footprints: [TripFootprintEntity] = [] { didSet { self.checkIsAvailableToSave() }}
    @Published var selectedFootprints: [TripFootprintEntity] = []
    
    @Published var startAtStatus: PeriodStatus = .unSelected { didSet { self.checkIsAvailableToSave() }}
    @Published var endAtStatus: PeriodStatus = .unSelected { didSet { self.checkIsAvailableToSave() }}
    @Published var icons: [TripIconEntity] = []
    
    var originalFootprints: [TripFootprintEntity] = []
    
    init(type: EditTripType) {
        self.type = type
        
        self.loadIcons()
        self.loadData(self.type)
    }
    
    private func loadIcons() {
        self.icons = self.loadTripIconsUseCase.execute()
    }
    
    private func loadData(_ type: EditTripType) {
        self.title = ""
        self.content = ""
        self.startAt = Date()
        self.endAt = Date()
        self.icon = nil
        self.footprints = self.loadFootprintsUseCase.execute()
        self.startAtStatus = .unSelected
        self.endAtStatus = .unSelected
        
        if case .modify(let id) = type {
            if let result = self.loadTripUseCase.execute(id) {
                self.title = result.title
                self.content = result.content
                self.startAt = Date(timeIntervalSince1970: Double(result.startAt))
                self.endAt = Date(timeIntervalSince1970: Double(result.endAt))
                self.icon = result.icon
                result.footprints.forEach { i in
                    if let idx = self.footprints.firstIndex(where: { item in
                        item.id == i.id
                    }) {
                        self.footprints[idx].idx = i.idx
                    }
                }
                self.startAtStatus = .selected
                self.endAtStatus = .selected
            } else {
                //TODO: fail to load
            }
        }
    }
    
    private func checkIsAvailableToSave() {
        self.isAvailableToSave = false
        if self.title.isEmpty || self.startAtStatus == .unSelected || self.endAtStatus == .unSelected || self.icon == nil || self.footprints.filter({ $0.idx != nil }).isEmpty {
            return
        }
        self.isAvailableToSave = true
    }
    
    func onSave(_ onDone: @escaping () -> ()) {
        switch self.type {
        case .create:
            self.save(onDone)
        case .modify(let id):
            self.update(id, onDone: onDone)
        }
    }
    
    func toggleFootprint(_ id: String) {
        guard let idx = self.footprints.firstIndex(where: { $0.id == id }) else { return }
        if let selectedIdx = self.footprints[idx].idx {
            self.footprints.indices.forEach { i in
                if let eachIdx = self.footprints[i].idx, eachIdx > selectedIdx {
                    self.footprints[i].idx! -= 1
                }
            }
            self.footprints[idx].idx = nil
        } else {
            let lastIdx = (self.footprints.compactMap({ $0.idx }).max() ?? -1) + 1
            self.footprints[idx].idx = lastIdx
        }
    }
    
    func setSelectedFootprints() {
        self.selectedFootprints = self.footprints.filter({ $0.idx != nil }).sorted(by: { lhs, rhs in
            lhs.idx! < rhs.idx!
        })
    }
    
    private func save(_ onDone: @escaping () -> ()) {
        if !self.isAvailableToSave { return }
        guard let icon = self.icon else { return }
        guard let result = self.saveTripUseCase.execute(
            title: self.title,
            content: self.content,
            iconId: icon.id,
            footprintIds: self.footprints.filter({ $0.idx != nil }).map({ $0.id }),
            startAt: Int(self.startAt.timeIntervalSince1970),
            endAt: Int(self.endAt.timeIntervalSince1970)
        ) else {
            // TODO: 저장 실패!
            return
        }
        onDone()
    }
    
    private func update(_ id: String, onDone: @escaping () -> ()) {
        if !self.isAvailableToSave { return }
        guard let icon = self.icon else { return }
        guard let result = self.updateTripUseCase.execute(
            id: id,
            title: self.title,
            content: self.content,
            iconId: icon.id,
            footprintIds: self.footprints.filter({ $0.idx != nil }).map({ $0.id }),
            startAt: Int(self.startAt.timeIntervalSince1970),
            endAt: Int(self.endAt.timeIntervalSince1970)
        ) else {
            // TODO: 업데이트 실패!
            return
        }
        onDone()
    }
}
