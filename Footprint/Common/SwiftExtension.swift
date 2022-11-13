//
//  SwiftExtension.swift
//  Footprint
//
//  Created by Studio-SJ on 2022/10/05.
//
import SwiftUI
import Combine

extension Int {
    func pinType() -> PinType {
        return PinType(rawValue: self) ?? .pin0
    }
    
    func getDate() -> String {
        let timeToDate = Date(timeIntervalSince1970: Double(self)) // 2021-10-13 17:16:15 +0000
        let date = DateFormatter()
        date.locale = Locale(identifier: "ko_kr")
        date.timeZone = TimeZone(abbreviation: "KST") // "2018-03-21 18:07:27"
        date.dateFormat = "MM월dd일 HH:mm"
        
        let kr = date.string(from: timeToDate)
        return kr
    }
}

extension Publisher {
    func run(in set: inout Set<AnyCancellable>, next: ((Self.Output) -> Void)? = nil, err errorListener: ((Error) -> Void)? = nil, complete: (() -> Void)? = nil) {
        self.subscribe(on: DispatchQueue.global(qos: .background))
            .receive(on: DispatchQueue.main)
            .sink { completion in
                if case let .failure(err) = completion {
                    errorListener?(err)
                }
                complete?()
            } receiveValue: { value in
                next?(value)
            }
            .store(in: &set)
    }
}
