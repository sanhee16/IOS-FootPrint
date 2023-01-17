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
    @Published var isOnSearchBar: Bool
    
    override init(_ coordinator: AppCoordinator) {
        self.isOnSearchBar = Util.getSettingStatus(.SEARCH_BAR)
        super.init(coordinator)
        print("init \(self.isOnSearchBar)")
    }
    
    func onAppear() {
        
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
            self.alert(.ok, description: "이메일을 보낼 수 있는 설정이 되어있지 않습니다.\n메일 앱에서 계정 연결 후, 메일 사용을 허용해 주세요.")
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
}
