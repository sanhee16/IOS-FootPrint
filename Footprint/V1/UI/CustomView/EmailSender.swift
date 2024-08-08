//
//  EmailSender.swift
//  Footprint
//
//  Created by sandy on 2022/10/08.
//

import Foundation
import MessageUI
import SwiftUI


struct EmailSender: UIViewControllerRepresentable {
    @Environment(\.presentationMode) var presentationMode
    
    func makeUIViewController(context: Context) -> MFMailComposeViewController {
        let mail = MFMailComposeViewController()
        let contents =
"""

"""
        
        mail.setToRecipients(["sinhioa20@naver.com"])
        mail.setMessageBody(contents, isHTML: false)
        
        // delegate 채택
        mail.mailComposeDelegate = context.coordinator
        return mail
    }
    
    func updateUIViewController(_ uiViewController: MFMailComposeViewController, context: Context) {}
    
    typealias UIViewControllerType = MFMailComposeViewController
    
    class Coordinator: NSObject, MFMailComposeViewControllerDelegate, UINavigationControllerDelegate {
        var parent: EmailSender
        
        init(_ parent: EmailSender) {
            self.parent = parent
        }
        
        func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
            controller.dismiss(animated: true, completion: nil)
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
}
