//
//  PermissionView.swift
//  Footprint
//
//  Created by sandy on 11/25/24.
//

import SwiftUI
import SDSwiftUIPack

struct PermissionView: View {
    struct Output {
        var pop: () -> ()
    }
    @StateObject private var vm: PermissionVM = PermissionVM()
    private var output: Output
    
    init(output: Output) {
        self.output = output
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Topbar("권한 확인하기", type: .back) {
                self.output.pop()
            }
            Text("원활한 사용을 위해 모든 권한허용을 추천합니다.\n권한 허용 후 사용되는 정보들은 수집되지 않습니다.")
                .multilineTextAlignment(.center)
                .sdFont(.headline4, color: .cont_gray_mid)
                .sdPaddingVertical(24)
                .frame(maxWidth: .infinity, alignment: .center)
            VStack(alignment: .leading) {
                SettingToggleItem(text: "위치 사용 권한", isOn: $vm.isAllowPhotoPermission)
                SettingToggleItem(text: "추적 권한", isOn: $vm.isAllowLocationPermission)
                SettingToggleItem(text: "사진 접근 권한", isOn: $vm.isAllowTrackingPermission)
                SettingToggleItem(text: "알림 허용", isOn: $vm.isAllowNotificationPermission)
            }
            .sdPaddingHorizontal(16)
            
            Spacer()
        }
        .navigationBarBackButtonHidden()
    }
}
