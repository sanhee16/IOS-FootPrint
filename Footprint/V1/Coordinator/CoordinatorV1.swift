//
//  CoordinatorV1.swift
//  Footprint
//
//  Created by Studio-SJ on 2022/10/05.
//


import SwiftUI
import SDSwiftUIPack
import MessageUI

protocol Terminatable {
    func appTerminate()
}

class CoordinatorV1 {
    var navigationController = UIViewController()
    var childViewControllers = [UIViewController]()
    var presentViewController: UIViewController {
        get {
            return childViewControllers.last ?? navigationController
        }
    }
    
    func present(_ viewController: UIViewController, animated: Bool = true, onDismiss: (() -> Void)? = nil) {
        if let baseViewController = viewController as? Dismissible {
            baseViewController.attachDismissCallback(completion: onDismiss)
        }
        
        self.presentViewController.present(viewController, animated: animated)
        self.childViewControllers.append(viewController)
    }
    
    func justPresent(_ viewController: UIViewController, animated: Bool = true, completion: (() -> Void)? = nil) {
        self.presentViewController.present(viewController, animated: animated, completion: completion)
    }
    
    func push(_ vc: UIViewController) {
        let lastVc = ((self.childViewControllers.last) ?? self.navigationController) as? UINavigationController
        lastVc?.pushViewController(vc, animated: true)
    }
    
    func change(_ viewController: UIViewController, animated: Bool = true, onDismiss: (() -> Void)? = nil) {
        dismiss(animated) { [weak self] in
            self?.present(viewController, animated: animated, onDismiss: onDismiss)
        }
    }
    
    func dismiss(_ animated: Bool = true, completion: (() -> Void)? = nil) {
        if self.childViewControllers.isEmpty {
            completion?()
            return
        }
        
        weak var dismissedVc = self.childViewControllers.removeLast()
        dismissedVc?.dismiss(animated: animated) {
            if let baseViewController = dismissedVc as? Dismissible,
               let completion = baseViewController.completion {
                completion()
            }
            completion?()
        }
    }
    
    func startProgress(_ animation: ProgressType = .loading) {
        SProgress.instance.startProgress(animation: animation)
    }
    
    func stopProgress() {
        SProgress.instance.stopProgress()
    }
    
    func popDismiss(target: UIViewController? = nil) {
        let before = self.childViewControllers.count
        if target == nil { // pop할 타겟 vc가 없어서 맨 마지막꺼 제거
            self.childViewControllers.remove(at: self.childViewControllers.count - 1)
            let after = self.childViewControllers.count
            print("[PopDismiss]", "TargetNil", "Before", before, "After", after)
        } else if let vc = target, let index = self.childViewControllers.firstIndex(of: vc) { // childControllers 중에서 target(타겟 vc)만 찾아서 pop
            self.childViewControllers.remove(at: index)
            let after = self.childViewControllers.count
            print("[PopDismiss]", type(of: vc), "Before", before, "After", after)
        }
    }

    func popLastDismiss() {
        self.childViewControllers.removeLast()
    }
    
    func sendEmail(_ messageBody: String, animated: Bool = true, onDismiss: (() -> Void)? = nil) {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            
            mail.setToRecipients(["sinhioa20@naver.com"])
            mail.setMessageBody(messageBody, isHTML: true)
            self.justPresent(mail, animated: animated, completion: onDismiss)
        } else {
            print("cannot send Email")
        }
    }
    
    func isCurrentVC(_ presentName: String) -> Bool {
        guard let last = self.childViewControllers.last else { return false }
        
        let lastType = type(of: last)
        let lastName = String(describing: lastType.self)
        
        return lastName.contains(presentName)
    }
    
    func isMain() -> Bool {
        guard let last = self.childViewControllers.last else { return false }
        
        let lastType = type(of: last)
        let lastName = String(describing: lastType.self)
        
        return lastName.contains(MainMenuType.map.viewName)
    }
    
}
