//
//  SProgress.swift
//  Footprint
//
//  Created by Studio-SJ on 2022/11/04.
//

import SwiftUI
import Foundation
import Lottie

public enum ProgressType {
    case loading
    
    func fileName() -> String {
        switch self {
        case .loading:
            return "loading"
        }
    }
    
    func size() -> CGSize {
        switch self {
        case .loading:
            return CGSize(width: 76, height: 76)
        }
    }
    
    func backgroundColor() -> UIColor {
        switch self {
        case .loading:
            return .init(red: 1, green: 1, blue: 1, alpha: 0.6)
        }
    }
}

class SProgress {
    public static let instance = SProgress()
    
    var backgroundView: UIView? = nil
    var animationView: AnimationView? = nil
    
    private init() {
    }
    
    public func startProgress(animation: ProgressType = .loading) {
        if backgroundView != nil {
            return
        }
        guard let window = UIApplication.shared.connectedScenes
            .filter({$0.activationState == .foregroundActive})
            .compactMap({$0 as? UIWindowScene})
            .first?.windows
            .filter({$0.isKeyWindow}).first else { return }
        let backgroundView = UIView(frame: UIScreen.main.bounds)
        backgroundView.backgroundColor = animation.backgroundColor() //UIColor(red: 1, green: 1, blue: 1, alpha: 0.6)
        
        let animationView = AnimationView(name: animation.fileName())
        animationView.loopMode = .loop
        
        backgroundView.addSubview(animationView)
        
        animationView.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.addConstraints([
            NSLayoutConstraint(item: animationView, attribute: .centerX, relatedBy: .equal, toItem: backgroundView, attribute: .centerX, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: animationView, attribute: .centerY, relatedBy: .equal, toItem: backgroundView, attribute: .centerY, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: animationView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: animation.size().width),
            NSLayoutConstraint(item: animationView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: animation.size().height)
        ])
        backgroundView.alpha = 0
        window.addSubview(backgroundView)
        
        animationView.play()
        UIView.animate(withDuration: 0.5) {
            backgroundView.alpha = 1
        }
        self.animationView = animationView
        self.backgroundView = backgroundView
    }
    
    public func stopProgress() {
        guard let backgroundView = backgroundView else {
            return
        }
        
        UIView.animate(withDuration: 0.5) {
            backgroundView.alpha = 0
        } completion: { complete in
            if complete {
                self.animationView?.stop()
                self.animationView?.removeFromSuperview()
                self.animationView = nil
                
                backgroundView.removeFromSuperview()
                self.backgroundView = nil
            }
        }
    }
}


