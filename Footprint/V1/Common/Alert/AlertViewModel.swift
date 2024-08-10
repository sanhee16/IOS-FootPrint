//
//  AlertViewModel.swift
//  Footprint
//
//  Created by sandy on 2022/10/09.
//

import Foundation
import Combine

enum AlertType {
    case ok
    case yesOrNo
}

class AlertViewModel: BaseViewModelV1 {
    @Published var type: AlertType
    @Published var title: String?
    @Published var description: String?
    private var callback: ((Bool) -> Void)?
    
    init(_ coordinator: AppCoordinator, type: AlertType, title: String?, description: String?, callback: ((Bool) -> Void)?) {
        self.type = type
        self.title = title
        self.description = description
        self.callback = callback
        super.init(coordinator)
    }
    
    func onAppear() {
        
    }
    
    func onClickOK() {
        self.dismiss(animated: false) {[weak self] in
            self?.callback?(true)
        }
    }
    
    func onClickCancel() {
        self.dismiss(animated: false) {[weak self] in
            self?.callback?(false)
        }
    }
    
    func onClose() {
        self.dismiss()
    }
}
