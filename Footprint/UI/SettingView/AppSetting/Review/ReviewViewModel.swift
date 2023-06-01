//
//  ReviewViewModel.swift
//  Footprint
//
//  Created by sandy on 2023/06/01.
//

import Foundation
import Combine
import AVFoundation
import Photos
import CoreLocation
import UserNotifications
import RealmSwift
import UIKit
import AppTrackingTransparency
import AdSupport
import FirebaseCore
import FirebaseFirestore



class ReviewViewModel: BaseViewModel {
    @Published var content: String = ""
    @Published var starCnt: Int = 0
    
    init(_ coordinator: AppCoordinator, star: Int) {
        self.starCnt = star
        super.init(coordinator)
    }
    
    func onAppear() {
    }
    
    func onClose() {
        self.dismiss(animated: false)
    }
    
    func sendFeedback() {
        FirestoreApi().postReview(ReviewModel(content: self.content, star: self.starCnt)) { [weak self] in
            self?.onClose()
        }
    }
}
