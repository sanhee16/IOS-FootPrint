//
//  PremiumCodeView.swift
//  Footprint
//
//  Created by Studio-SJ on 2023/03/22.
//

import SwiftUI
import SDSwiftUIPack

struct PremiumCodeView: View {
    typealias VM = PremiumCodeViewModel
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
    private let itemWidth: CGFloat = UIScreen.main.bounds.width - 80 - 24
    
    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .center, spacing: 0) {
                Spacer()
                VStack(alignment: .center, spacing: 0) {
                    Topbar("enter_premium_code".localized(), type: .close) {
                        vm.onClose()
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        TextField("premium_name".localized(), text: $vm.name)
                            .font(.kr12r)
                            .padding()
                            .frame(width: itemWidth, height: 28, alignment: .center)
                            .background(
                                RoundedRectangle(cornerRadius: 6)
                                    .foregroundColor(.inputBoxColor)
                            )
                        TextField("premium_code".localized(), text: $vm.code)
                            .font(.kr12r)
                            .padding()
                            .frame(width: itemWidth, height: 28, alignment: .center)
                            .background(
                                RoundedRectangle(cornerRadius: 6)
                                    .foregroundColor(.inputBoxColor)
                            )
                    }
                    .padding([.top, .bottom], 10)
                    
                    Text("confirm".localized())
                        .font(.kr13r)
                        .foregroundColor(.white)
                        .frame(width: itemWidth, height: 30, alignment: .center)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .foregroundColor(.fColor3)
                        )
                        .onTapGesture {
                            vm.onClickSubmit()
                        }
                }
                .padding(.bottom, 10)
                .background(
                    RoundedRectangle(cornerRadius: 18)
                        .foregroundColor(Color.white)
                )
                .frame(width: UIScreen.main.bounds.width - 80, alignment: .center)
                .onAppear {
                    vm.onAppear()
                }
                Spacer()
            }
            .padding([.leading, .trailing], 40)
        }
    }
}
