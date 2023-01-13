//
//  CheckPermissionView.swift
//  Footprint
//
//  Created by sandy on 2022/12/07.
//

import SwiftUI

struct CheckPermissionView: View {
    typealias VM = CheckPermissionViewModel
    public static func vc(_ coordinator: AppCoordinator, completion: (()-> Void)? = nil) -> UIViewController {
        let vm = VM.init(coordinator)
        let view = Self.init(vm: vm)
        let vc = BaseViewController.init(view, completion: completion)
        vc.modalPresentationStyle = .overCurrentContext
        vc.view.backgroundColor = UIColor.clear
        vc.controller.view.backgroundColor = UIColor.dim
        return vc
    }
    
    @ObservedObject var vm: VM
    
    private var safeTop: CGFloat { get { Util.safeTop() }}
    private var safeBottom: CGFloat { get { Util.safeBottom() }}
    
    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .center, spacing: 0) {
                Spacer()
                VStack(alignment: .center, spacing: 0) {
                    Topbar("권한 확인하기", type: .close) {
                        vm.onClose()
                    }
                    Text("원활한 사용을 위해 모든 권한허용을 추천합니다.\n권한 허용 후 사용되는 정보들은 수집되지 않습니다.")
                        .font(.kr9r)
                        .foregroundColor(.gray60)
                        .multilineTextAlignment(.center)
                        .frame(width: UIScreen.main.bounds.width - 100, alignment: .center)
                        .padding(.bottom, 4)
                    VStack(alignment: .center, spacing: 10) {
                        drawPermissionItem(geometry, text: "위치사용권한", isAllow: C.permissionLocation)
                        drawPermissionItem(geometry, text: "카메라사용권한", isAllow: $vm.cameraPermission.wrappedValue)
                        drawPermissionItem(geometry, text: "사진접근권한", isAllow: $vm.photoPermission.wrappedValue)
                        drawPermissionItem(geometry, text: "알림허용", isAllow: $vm.notiPermission.wrappedValue)
                    }
                    .padding([.top, .bottom], 10)
                }
                .background(
                    RoundedRectangle(cornerRadius: 18)
                        .foregroundColor(Color.white)
                )
                .frame(width: UIScreen.main.bounds.width - 100, alignment: .center)
                .onAppear {
                    vm.onAppear()
                }
                Spacer()
            }
            .padding([.leading, .trailing], 50)
        }
    }
    
    private func drawPermissionItem(_ geometry: GeometryProxy, text: String, isAllow: Bool) -> some View {
        return HStack(alignment: .center, spacing: 0) {
            Text(text)
                .font(.kr11r)
                .foregroundColor(.textColor1)
            Spacer()
            if isAllow {
                Text("ON")
                    .font(.kr11b)
                    .foregroundColor(.white)
                    .frame(width: 38, height: 25, alignment: .center)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .foregroundColor(.green)
                    )
            } else {
                Text("OFF")
                    .font(.kr11b)
                    .foregroundColor(.white)
                    .frame(width: 38, height: 25, alignment: .center)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .foregroundColor(.red)
                    )
                    .onTapGesture {
                        vm.openAppSetting()
                    }
            }
        }
        .padding([.leading, .trailing], 18)
    }
}
