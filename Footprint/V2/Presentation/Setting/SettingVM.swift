//
//  SettingVM.swift
//  Footprint
//
//  Created by sandy on 11/24/24.
//

import Combine
import Factory
import Foundation

class SettingVM: ObservableObject {
    @Injected(\.saveNoteUseCase) var saveNoteUseCase
    @Injected(\.loadCategoriesUseCase) var loadCategoriesUseCase
    @Injected(\.saveTripUseCase) var saveTripUseCase
    @Injected(\.loadAllNoteUseCase) var loadAllNoteUseCase
    @Injected(\.loadTripIconsUseCase) var loadTripIconsUseCase
    
    
    
    //MARK: DebugMode
    func addData() {
        self.addNotes()
        self.addTrips()
        
    }
    
    func addNotes() {
        let categories: [CategoryEntity] = self.loadCategoriesUseCase.execute()
        let coordinates: [(Double, Double, String)] = [
            (37.323562519200344, 127.09580697119236, "대한민국 경기도 용인시 풍덕천동 712-6 16837"),
            (37.322598949458204, 127.09686610847713, "대한민국 경기도 용인시 풍덕천동 790 16835"),
            (37.323562519200344, 127.09580697119236, "대한민국 경기도 용인시 풍덕천동 712-6 16837"),
            (37.32397017960268, 127.09449972957374, "대한민국 경기도 용인시 정평로 120 16836"),
            (37.32305700656524, 127.0955816656351, "대한민국 경기도 용인시 풍덕천로 119 16836"),
            (37.323562519200344, 127.09580697119236, "대한민국 경기도 용인시 풍덕천동 712-6 16837"),
            (37.322582418823586, 127.09461405873299, "대한민국 경기도 용인시 풍덕천로 117 16836"),
            (37.3241272175849, 127.09613822400571, "대한민국 경기도 용인시 풍덕천로129번길 6-5 16837"),
            (37.32366410123411, 127.09638163447379, "대한민국 경기도 용인시 풍덕천로 133 16837"),
            (37.32363690605743, 127.09794268012047, "대한민국 경기도 용인시 풍덕천로140번길 5-12 16835"),
            (37.32241577915837, 127.09573321044446, "대한민국 경기도 용인시 풍덕천동 1080-18 16841"),
            (37.32409655654456, 127.09620527923107, "대한민국 경기도 용인시 풍덕천로129번길 16837"),
            (37.3241272175849, 127.09613822400571, "대한민국 경기도 용인시 풍덕천로129번길 6-5 16837")
        ]
        
        for i in 0..<coordinates.count {
            self.saveNoteUseCase.execute(
                title: "노트 추가 \(i)번",
                content: "I still remember back in 2014 when I began my journey into mobile development. At the time, everyone was exploring this greenfield, searching for the best architecture suited to mobile applications. The Clean Architecture, introduced by Uncle Bob in 2012, quickly became a reference point for many, emphasizing proper modularization and decoupling to maintain a clean, manageable codebase and avoid chaotic dependencie\n\nThis is a great starting point for mobile development as well. Many mobile developers have explored how it can be applied to mobile applications. Numerous articles and diagrams illustrate these approaches, as shown below",
                createdAt: Int(Date().timeIntervalSince1970),
                imageUrls: [],
                category: categories.randomElement() ?? categories.first!,
                members: [],
                isStar: [true, false].randomElement()!,
                latitude: coordinates[i].0,
                longitude: coordinates[i].1,
                address: coordinates[i].2
            )
        }
        
    }
    
    func addTrips() {
        let notes: [String] = self.loadAllNoteUseCase.execute(.earliest).map({ $0.id })
        let icons: [String] = self.loadTripIconsUseCase.execute().map({ $0.id})
        
        for i in 0..<10 {
            self.saveTripUseCase.execute(
                title: "발자취 추가 \(i)번",
                content: "No one is perfect and that applies to high performers on your team too. They may be doing excellent work or exceeding your expectations, but that doesn’t make them flawless or leave them with no room for improvement or areas of growth.\nYou’re not doing enough if all you do is pass occasional remarks to appreciate their work",
                iconId: icons.randomElement()!,
                footprintIds: Array(notes.shuffled().prefix((3..<notes.count).randomElement()!)),
                startAt: Int(Date().timeIntervalSince1970),
                endAt: Int(Date().timeIntervalSince1970)
            )
        }
    }
}
