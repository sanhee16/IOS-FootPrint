//
//  BaseViewModel.swift
//  Footprint
//
//  Created by Studio-SJ on 2022/10/05.
//


import Foundation
import SwiftUI
import Combine

class BaseViewModel: ObservableObject {
    weak var coordinator: AppCoordinator? = nil
    var subscription = Set<AnyCancellable>()
    
    init() {
        print("init \(type(of: self))")
        self.coordinator = nil
    }
    
    init(_ coordinator: AppCoordinator) {
        print("init \(type(of: self))")
        self.coordinator = coordinator
    }
    
    deinit {
        subscription.removeAll()
    }
    
    public func startProgress(_ animation: ProgressType = .loading) {
        self.coordinator?.startProgress(animation)
    }
    
    public func stopProgress() {
        self.coordinator?.stopProgress()
    }
    
    public func dismiss(animated: Bool = true, completion: (() -> Void)? = nil) {
        self.coordinator?.dismiss(animated, completion: completion)
    }
    
    public func present(_ vc: UIViewController, animated: Bool = true) {
        self.coordinator?.present(vc, animated: animated)
    }
    
    public func change(_ vc: UIViewController, animated: Bool = true) {
        self.coordinator?.change(vc, animated: animated)
    }
}

