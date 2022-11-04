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
        VStack(alignment: .center, spacing: 10) {
            if let title = $vm.title.wrappedValue {
                Text(title)
                    .font(.kr18b)
                    .foregroundColor(.gray100)
            }
            if let description = $vm.description.wrappedValue {
                Text(description)
                    .multilineTextAlignment(.center)
                    .font(.kr14r)
                    .foregroundColor(.gray60)
            }
            HStack(alignment: .center, spacing: 0) {
                if $vm.type.wrappedValue == .ok {
                    Text("OK")
                        .font(.kr16b)
                        .foregroundColor(.gray90)
                        .onTapGesture {
                            vm.onClickOK()
                        }
                } else {
                    Text("OK")
                        .font(.kr16r)
                        .foregroundColor(.gray90)
                        .frame(width: (UIScreen.main.bounds.width - 100)/2)
                        .onTapGesture {
                            vm.onClickOK()
                        }
                    Text("Cancel")
                        .font(.kr16r)
                        .foregroundColor(.gray60)
                        .frame(width: (UIScreen.main.bounds.width - 100)/2)
                        .onTapGesture {
                            vm.onClickCancel()
                        }
                }
            }
            .padding([.top, .bottom], 10)
        }
        .padding(EdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20))
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
