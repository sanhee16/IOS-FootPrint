//
//  SettingViewModel.swift
//  Footprint
//
//  Created by sandy on 2022/12/05.
//



import Foundation
import Combine
import UIKit
import MessageUI

class SettingViewModel: BaseViewModel {
    @Published var isShowingMailView = false
    @Published var result: Result<MFMailComposeResult, Error>? = nil
    
    override init(_ coordinator: AppCoordinator) {
        super.init(coordinator)
        
    }
    
    func onAppear() {
        
    }
    
    func onClose() {
        self.dismiss()
    }
    
    func onClickContact() {
        if MFMailComposeViewController.canSendMail() {
            self.isShowingMailView = true
        } else {
            self.alert(.ok, description: "이메일을 보낼 수 있는 설정이 되어있지 않습니다.\n메일 앱에서 계정 연결 후, 메일 사용을 허용해 주세요.")
        }
    }
}
