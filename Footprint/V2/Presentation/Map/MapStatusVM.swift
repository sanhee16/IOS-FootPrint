////
////  MapStatusVM.swift
////  Footprint
////
////  Created by sandy on 11/5/24.
////
//
//import Foundation
//
//enum MapStatus: String {
//    case normal
//    case adding
//}
//
//class MapStatusVM: ObservableObject {
//    @Published var status: MapStatus = .normal
//    static var tempNote: TempNote? = nil
//    
//    init() {
//        addObserver()
//    }
//    
//    func addObserver() {
//        NotificationCenter.default.addObserver(
//            self,
//            selector: #selector(
//                didRecieveChangeMapStatusNotification(
//                    _:
//                )
//            ),
//            name: .changeMapStatus,
//            object: nil
//        )
//    }
//
//    @objc func didRecieveChangeMapStatusNotification(_ notification: Notification) {
//        let getValue = notification.object as! String
//        print("didRecieveChangeMapStatusNotification: \(getValue)")
//        if let status = MapStatus(rawValue: getValue) {
//            self.updateMapStatus(status)
//        }
//    }
//
//    func updateMapStatus(_ status: MapStatus) {
//        print("updateMapStatus: \(status.rawValue)")
//        self.status = status
//        switch status {
//        case .normal:
//            Self.tempNote = nil
//            NotificationCenter.default.post(name: .isShowTabBar, object: true)
//            break
//        case .adding:
//            NotificationCenter.default.post(name: .isShowTabBar, object: false)
//            break
//        }
//    }
//    
//}
