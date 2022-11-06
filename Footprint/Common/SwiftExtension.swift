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
