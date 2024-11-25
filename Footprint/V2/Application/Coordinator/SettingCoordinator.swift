//
//  SettingCoordinator.swift
//  Footprint
//
//  Created by sandy on 11/24/24.
//

import Foundation

class SettingCoordinator: BaseCoordinator<Destination> {
    private func pushCategoryListEditView() {
        self.push(.categoryListEditView(output: categoryListEditViewOutput))
    }
    
    private func pushMemberListEditView() {
        self.push(.peopleWithListEditView(output: memberListEditViewOutput))
    }
    
    private func pushSetMapIconView() {
        self.push(.setMapIconView)
    }
    
    private func pushPermissionView() {
        self.push(.permissionView(output: permissionViewOutput))
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
    var permissionViewOutput: PermissionView.Output {
        PermissionView.Output {
            self.pop()
        }
    }
    
    var settingOutput: SettingView.Output {
        SettingView.Output {
            self.pushSetMapIconView()
        } pushPermissionView: {
            self.pushPermissionView()
        } pushMemberListEditView: {
            self.pushMemberListEditView()
        } pushCategoryListEditView: {
            self.pushCategoryListEditView()
        } pushPrivacyPolicyView: {
            self.pushPrivacyPolicyView()
        }
    }
}

