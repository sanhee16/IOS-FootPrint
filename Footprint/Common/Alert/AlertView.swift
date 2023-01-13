//
//  AlertView.swift
//  Footprint
//
//  Created by sandy on 2022/10/09.
//

import SwiftUI

struct AlertView: View {
    typealias VM = AlertViewModel
    public static func vc(_ coordinator: AppCoordinator, type: AlertType, title: String?, description: String?, callback: ((Bool) -> ())?, completion: (()-> Void)? = nil) -> UIViewController {
        let vm = VM.init(coordinator, type: type, title: title, description: description, callback: callback)
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
        VStack(alignment: .center, spacing: 0) {
            VStack(alignment: .center, spacing: 20) {
                if let title = $vm.title.wrappedValue {
                    Text(title)
                        .font(.kr15b)
                        .foregroundColor(.textColor1)
                        .multilineTextAlignment(.center)
                }
                if let description = $vm.description.wrappedValue {
                    Text(description)
                        .font(.kr14r)
                        .foregroundColor(.gray90)
                        .multilineTextAlignment(.center)
                }
            }
            .padding([.leading, .trailing, .top], 20)
            Divider()
                .padding(.top, 20)
            HStack(alignment: .center, spacing: 0) {
                if $vm.type.wrappedValue == .ok {
                    Text("OK")
                        .font(.kr14r)
                        .foregroundColor(.gray90)
                        .onTapGesture {
                            vm.onClickOK()
                        }
                } else {
                    Text("OK")
                        .font(.kr14r)
                        .foregroundColor(.gray90)
                        .frame(width: (UIScreen.main.bounds.width - 100)/2)
                        .onTapGesture {
                            vm.onClickOK()
                        }
                    Divider()
                        .frame(height: 40, alignment: .center)
                    Text("Cancel")
                        .font(.kr14r)
                        .foregroundColor(.gray60)
                        .frame(width: (UIScreen.main.bounds.width - 100)/2)
                        .onTapGesture {
                            vm.onClickCancel()
                        }
                }
            }
            .frame(width: UIScreen.main.bounds.width - 100, height: 40, alignment: .center)
            .padding([.leading, .trailing], 20)
        }
        .frame(width: UIScreen.main.bounds.width - 100, alignment: .center)
        .background(
            RoundedRectangle(cornerRadius: 18)
                .foregroundColor(Color.white)
        )
        .onAppear {
            vm.onAppear()
        }
    }
}
