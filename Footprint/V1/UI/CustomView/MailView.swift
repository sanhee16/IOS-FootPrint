//
//  MailView.swift
//  Footprint
//
//  Created by sandy on 2022/12/05.
//

import UIKit
import SwiftUI
import SDSwiftUIPack
import MessageUI

struct MailView: UIViewControllerRepresentable {
    
    @Binding var isShowing: Bool
    @Binding var result: Result<MFMailComposeResult, Error>?
    
    class Coordinator: NSObject, MFMailComposeViewControllerDelegate {
        
        @Binding var isShowing: Bool
        @Binding var result: Result<MFMailComposeResult, Error>?
        
        init(isShowing: Binding<Bool>,
             result: Binding<Result<MFMailComposeResult, Error>?>) {
            _isShowing = isShowing
            _result = result
        }
        
        func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
            defer {
                isShowing = false
            }
            guard error == nil else {
                self.result = .failure(error!)
                return
            }
            self.result = .success(result)
        }
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(isShowing: $isShowing, result: $result)
    }
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<MailView>) -> MFMailComposeViewController {
        let vc = MFMailComposeViewController()
        vc.setToRecipients(["sandy.park.dev@gmail.com"])
        var version: String? {
            guard let dictionary = Bundle.main.infoDictionary,
                  let version = dictionary["CFBundleShortVersionString"] as? String,
                  let build = dictionary["CFBundleVersion"] as? String else {return nil}
            
            let versionAndBuild: String = "vserion: \(version), build: \(build)"
            return versionAndBuild
        }
        let appVersion = version ?? "unknown"
        let osVersion = UIDevice.current.systemVersion
        let messageBody =
        """
        <p>
        -----------------------------------------<br/>
        App-Version : \(appVersion)<br/>
        OS-Version : \(osVersion)<br/>
        -----------------------------------------<br/>
        </p>
        """
        vc.setMessageBody(messageBody, isHTML: true)
        vc.mailComposeDelegate = context.coordinator
        return vc
    }
    
    func updateUIViewController(_ uiViewController: MFMailComposeViewController, context: UIViewControllerRepresentableContext<MailView>) {
        
    }
}
