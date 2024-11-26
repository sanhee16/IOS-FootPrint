//
//  SettingVM.swift
//  Footprint
//
//  Created by sandy on 11/24/24.
//

import Combine
import Factory
import Foundation
import CoreLocation
import Contacts
import MapKit

class SettingVM: ObservableObject {
    @Injected(\.saveNoteUseCase) var saveNoteUseCase
    @Injected(\.loadCategoriesUseCase) var loadCategoriesUseCase
    @Injected(\.saveTripUseCase) var saveTripUseCase
    @Injected(\.loadAllNoteUseCase) var loadAllNoteUseCase
    @Injected(\.loadTripIconsUseCase) var loadTripIconsUseCase
    @Injected(\.getIsShowSearchBarUseCase) var getIsShowSearchBarUseCase
    @Injected(\.updateIsShowSearchBarUseCase) var updateIsShowSearchBarUseCase
        
    @Published var isShowSearchBar: Bool = false {
        didSet { self.updateIsShowSearchBar() }
    }
    var url: String? = nil
    
    
    init() {
        self.getPrivacyPolicyUrl()
        self.getIsShowSearchBar()
    }
    
    func getIsShowSearchBar() {
        isShowSearchBar = self.getIsShowSearchBarUseCase.execute()
    }
    
    func updateIsShowSearchBar() {
        let _ = self.updateIsShowSearchBarUseCase.execute(self.isShowSearchBar)
    }
    
    //MARK: DebugMode
    func addData() {
        Task {
            await self.addNotes()
            self.addTrips()
        }
    }
    
    func getPrivacyPolicyUrl() {
        if let lan = UserLocale.currentLanguage() {
            self.url = lan == "ko" ? "https://sanhee16.github.io/footprint-policy/ko/privacy.html" : "https://sanhee16.github.io/footprint-policy/en/privacy.html"
        }
    }
    
    
    private func addNotes() async {
        func getAddress(lat: Double, lon: Double) async -> String {
            let geocoder = CLGeocoder()
            var addr: String = ""
            
            do {
                let address = try await geocoder.reverseGeocodeLocation(CLLocation(latitude: lat, longitude: lon), preferredLocale: Locale(identifier: "Ko-kr")).last
                if let postalAddress = address?.postalAddress {
                    let formatter = CNPostalAddressFormatter()
                    let addressString = formatter.string(from: postalAddress)
                    
                    var result: String = ""
                    addressString.split(separator: "\n").forEach { value in
                        result.append(contentsOf: "\(value) ")
                    }
                    addr = result
                } 
                return addr
            } catch {
                return addr
            }
        }
        
        let locationManager: CLLocationManager = CLLocationManager()
        var latitude = 37.323562519200344
        var longitude = 127.09580697119236
        var coordinates: [(Double, Double, String)] = []
        
        if let coor = locationManager.location?.coordinate {
            latitude = coor.latitude
            longitude = coor.longitude
        }
        
        let values: [Double] = [0.0001, 0.0002, 0.0003, 0.0004, 0.0005, 0.0006, 0.0007, -0.0001, -0.0002, -0.0003, -0.0004, -0.0005, -0.0006, -0.0007]
        
        for i in values.indices {
            let lat = latitude + values[i]
            let lon = longitude + values.randomElement()!
            let address = await getAddress(lat: lat, lon: lon)
            coordinates.append((lat, lon, address))
        }
        
        for i in 0..<3 {
            let lat = latitude
            let lon = longitude
            let address = await getAddress(lat: lat, lon: lon)
            coordinates.append((lat, lon, address))
        }
    
        let categories: [CategoryEntity] = self.loadCategoriesUseCase.execute()
        
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
    private func addTrips() {
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
