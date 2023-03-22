//
//  PremiumCodeViewModel.swift
//  Footprint
//
//  Created by Studio-SJ on 2023/03/22.
//


import Foundation
import UIKit


class PremiumCodeViewModel: BaseViewModel {
    @Published var name: String = ""
    @Published var code: String = ""
    
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
        //TODO: firestore 연결하고 userDefaults에 저장
        
        self.alert(.ok, title: "프리미엄 등록이 완료되었습니다.") {[weak self] _ in
            self?.dismiss()
        }
    }
    
    
    
}
