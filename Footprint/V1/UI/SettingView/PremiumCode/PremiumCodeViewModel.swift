//
//  PremiumCodeViewModel.swift
//  Footprint
//
//  Created by Studio-SJ on 2023/03/22.
//


import Foundation
import UIKit
import FirebaseCore
import FirebaseFirestore

class PremiumCodeViewModel: BaseViewModel {
    @Published var name: String = ""
    @Published var code: String = ""
    private let firestoreApi = FirestoreApi.shared
    override init(_ coordinator: AppCoordinator) {
        super.init(coordinator)
    }
    
    func onAppear() {
        
    }
    
    func onClose() {
        self.dismiss(animated: false)
    }
    
    func onClickSubmit() {
        if name.isEmpty {
            self.alert(.ok, title: "이름을 입력해주세요", description: "코드 사용자가 누구인지 식별하기 위한 입력입니다")
            return
        } else if code.isEmpty {
            self.alert(.ok, title: "코드를 입력해주세요")
            return
        }
        
        print("onClickSubmit")
        firestoreApi.getPremiumTier(documentID: self.code) {[weak self] item in
            guard let self = self, let item = item else {
                self?.alert(.ok, title: "잘못된 코드입니다.")
                return
            }
            if item.isUsing {
                self.alert(.ok, title: "이미 사용중인 코드입니다.")
                return
            }
            var updateItem = item
            updateItem.isUsing = true
            updateItem.name = self.name
            self.firestoreApi.updatePremiumTier(documentID: self.code, originalPersonRequest: updateItem) {[weak self] item in
                guard let self = self, let item = item else {
                    self?.alert(.ok, title: "오류가 발생했습니다.")
                    return
                }
                
                Defaults.premiumCode = self.code
                self.alert(.ok, title: "프리미엄 등록이 완료되었습니다.") {[weak self] _ in
                    self?.dismiss()
                }
            }
        }
    }
    
    
    
}
