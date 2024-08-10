//
//  BaseViewModelV1.swift
//  Footprint
//
//  Created by Studio-SJ on 2022/10/05.
//


import Foundation
import SwiftUI
import SDSwiftUIPack
import Combine
import UIKit
import RealmSwift


class BaseViewModelV1: ObservableObject {
    weak var coordinator: AppCoordinatorV1? = nil
    var subscription = Set<AnyCancellable>()
    
    init() {
        print("init \(type(of: self))")
        self.coordinator = nil
    }
    
    init(_ coordinator: AppCoordinatorV1) {
        print("init \(type(of: self))")
        self.coordinator = coordinator
    }
    
    deinit {
        subscription.removeAll()
    }
    
    public func checkNetworkConnect(_ callback: (()->())? = nil) {
        if NetworkMonitor.shared.isConnected {
            callback?()
            return
        } else {
            self.alert(.ok, title: "no_network".localized(), description: "no_network_description".localized()) { _ in
                UIApplication.shared.perform(#selector(NSXPCConnection.suspend))
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                    exit(0)
                }
            }
        }
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
    
    public func alert(_ type: AlertType, title: String? = nil, description: String? = nil, callback: ((Bool) -> ())? = nil) {
        self.coordinator?.presentAlertView(type, title: title, description: description, callback: callback)
    }
}

