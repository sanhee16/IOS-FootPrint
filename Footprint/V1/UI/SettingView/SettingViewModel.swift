//
//  SettingViewModel.swift
//  Footprint
//
//  Created by sandy on 2022/12/05.
//



import Foundation
import Combine
import MessageUI
import SwiftUI

class SettingViewModel: BaseViewModel {
    @Published var isShowingMailView = false
    @Published var result: Result<MFMailComposeResult, Error>? = nil
    @Published var isOnSearchBar: Bool
    
    @Published var tapCnt: Int = 0
    @Published var starCnt: Int = 0
    
    override init(_ coordinator: AppCoordinator) {
        self.isOnSearchBar = Util.getSettingStatus(.SEARCH_BAR)
        super.init(coordinator)
    }
    
    func onAppear() {
        checkNetworkConnect {[weak self] in
            guard let self = self else { return }
            self.tapCnt = 0
            C.isDebugMode = false
        }
    }
    
    func onClose() {
        self.dismiss()
    }
    
    //MARK: onClickSettingItem
    func onClickTrash() {
        self.coordinator?.presentTrashView()
    }
    
    func onClickCheckPermission() {
        self.coordinator?.presentCheckPermission()
    }
    
    func onClickContact() {
        if MFMailComposeViewController.canSendMail() {
            self.isShowingMailView = true
        } else {
            self.alert(.ok, description: "alert_no_email".localized())
        }
    }
    
    func onClickDevInfo() {
        self.coordinator?.presentDevInfoView()
    }
    
    func onClickEditPeopleWith() {
//        self.coordinator?.presentPeopleWithEditView()
        self.coordinator?.presentPeopleWithSelectorView(type: .edit)
    }
    
    func onClickEditCategory() {
        self.coordinator?.presentCategorySelectorView(type: .edit)
    }
    
    func onToggleSetting(_ flag: SettingFlag, isOn: Bool) {
        print("isOn? \(isOn)")
        Util.setSettingStatus(flag, isOn: isOn)
    }
    
    func onClickTitle() {
        self.tapCnt += 1
        if self.tapCnt > 30 {
            withAnimation {
                C.isDebugMode = true
            }
        }
    }
    
    func onClickEnterPremiumCode() {
        self.coordinator?.presentPremiumCodeView()
    }
    
    func onClickPrivacyPolicy() {
        guard let lan = UserLocale.currentLanguage() else { return }
        let urlAdr: String = lan == "ko" ? "https://sanhee16.github.io/footprint-policy/ko/privacy.html" : "https://sanhee16.github.io/footprint-policy/en/privacy.html"
        if let url = URL(string: urlAdr) {
            let options: [UIApplication.OpenExternalURLOptionsKey: Any] = [:]
            UIApplication.shared.open(url, options: options) { success in
                if success {
                    print("Link opened successfully")
                } else {
                    print("Error: Failed to open link")
                }
            }
        }
    }
    
    func onEnterStar(_ idx: Int) {
        self.starCnt = idx + 1
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            guard let self = self else { return }
            if self.starCnt >= 4 && Util.getSettingStatus(.REVIEW) {
                Util.setSettingStatus(.REVIEW, isOn: false)
                // TODO: 리뷰 페이지로 넘어가기 => 실 기기에서 확인 필요
                if let appstoreUrl = URL(string: "https://apps.apple.com/app/id6448868585") {
                    var urlComp = URLComponents(url: appstoreUrl, resolvingAgainstBaseURL: false)
                    urlComp?.queryItems = [
                        URLQueryItem(name: "action", value: "write-review")
                    ]
                    guard let reviewUrl = urlComp?.url else {
                        return
                    }
                    UIApplication.shared.open(reviewUrl, options: [:], completionHandler: nil)
                }

            } else {
                // dialog
                self.coordinator?.presentReviewView(self.starCnt)
            }
        }
    }
    
    func resetSettingStatus() {
//        Util.setSettingStatus(.REVIEW, isOn: true)
//        print("- settingStatus: \(Util.getSettingStatus(.REVIEW))")
    }
}
