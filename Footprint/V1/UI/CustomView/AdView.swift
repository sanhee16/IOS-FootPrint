//
//  AdBanner.swift
//  Footprint
//
//  Created by Studio-SJ on 2023/03/22.
//

import Foundation
import SwiftUI
import SDSwiftUIPack
import GoogleMobileAds


/*
 usage: GADBanner().frame(width: GADAdSizeBanner.size.width, height: GADAdSizeBanner.size.height)
 */
struct GADBanner: UIViewControllerRepresentable {
    
    func makeUIViewController(context: Context) -> some UIViewController {
        let view = GADBannerView(adSize: GADAdSizeBanner)
        let viewController = UIViewController()
        view.adUnitID = C.devMode == .develop ? "ca-app-pub-3940256099942544/2934735716" : Bundle.main.gadBannerId
        view.rootViewController = viewController
        viewController.view.addSubview(view)
        viewController.view.frame = CGRect(origin: .zero, size: GADAdSizeBanner.size)
        view.load(GADRequest())
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
}
