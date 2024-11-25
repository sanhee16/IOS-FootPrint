//
//  SettingCoordinator.swift
//  Footprint
//
//  Created by sandy on 11/24/24.
//

import Foundation

class SettingCoordinator: BaseCoordinator<Destination> {
    private func pushCategoryListEditView(_ output: CategoryListEditView.Output) {
        self.push(.categoryListEditView(output: output))
    }
    
    private func pushMemberListEditView(_ output: MemberListEditView.Output) {
        self.push(.peopleWithListEditView(output: output))
    }
    
    private func pushSetMapIconView() {
        self.push(.setMapIconView)
    }
    
    private func pushPermissionView() {
        self.push(.permissionView)
    }
    
    private func pushPrivacyPolicyView() {
        self.push(.privacyPolicyView)
    }
}

//MARK: Output
extension SettingCoordinator {
    var categoryListEditViewOutput: CategoryListEditView.Output {
        CategoryListEditView.Output {
            self.pop()
        }
    }
    
    var memberListEditViewOutput: MemberListEditView.Output {
        MemberListEditView.Output {
            self.pop()
        }
    }
    
    var settingOutput: SettingView.Output {
        SettingView.Output {
            self.pushSetMapIconView()
        } pushPermissionView: {
            self.pushPermissionView()
        } pushMemberListEditView: {
            self.pushMemberListEditView(self.memberListEditViewOutput)
        } pushCategoryListEditView: {
            self.pushCategoryListEditView(self.categoryListEditViewOutput)
        } pushPrivacyPolicyView: {
            self.pushPrivacyPolicyView()
        }
    }
}

