//
//  ReviewView.swift
//  Footprint
//
//  Created by sandy on 2023/06/01.
//

import SwiftUI
import SDSwiftUIPack

struct ReviewView: View {
    typealias VM = ReviewViewModel
    public static func vc(_ coordinator: AppCoordinatorV1, star: Int, completion: (()-> Void)? = nil) -> UIViewController {
        let vm = VM.init(coordinator, star: star)
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
                    Topbar("feedback_title".localized(), type: .close) {
                        vm.onClose()
                    }
                    
                    HStack(alignment: .center, spacing: 8) {
                        ForEach(0..<5, id: \.self) { idx in
                            Image(idx < $vm.starCnt.wrappedValue ? "star_on" : "star_off")
                                .resizable()
                                .scaledToFit()
                                .frame(both: 18.0, alignment: .center)
                                .onTapGesture {
                                    $vm.starCnt.wrappedValue = idx + 1
                                }
                        }
                    }
                    Text("enter_feedback_content".localized())
                        .font(.kr10r)
                        .foregroundColor(.gray60)
                        .multilineTextAlignment(.center)
                        .lineLimit(nil)
                        .frame(width: UIScreen.main.bounds.width - 100, alignment: .center)
                        .padding([.top, .bottom], 10)
                    
                    MultilineTextField("", text: $vm.content) {
                        
                    }
                    .frame(minHeight: 120.0, alignment: .topLeading)
                    .padding(EdgeInsets(top: 6, leading: 10, bottom: 6, trailing: 10))
                    .contentShape(Rectangle())
                    .background(
                        RoundedRectangle(cornerRadius: 2)
                            .foregroundColor(.inputBoxColor)
                    )
                    .onChange(of: $vm.content.wrappedValue) { value in
                        if value == " " {
                            $vm.content.wrappedValue = ""
                        }
                    }
                    .padding(EdgeInsets(top: 4, leading: 16, bottom: 10, trailing: 16))
                    
                    
                    Text("send".localized())
                        .font(.kr16b)
                        .foregroundColor(.white)
                        .frame(width: geometry.size.width - 100 - 32, height: 40, alignment: .center)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .foregroundColor(.fColor2)
                        )
                        .onTapGesture {
                            vm.sendFeedback()
                        }
                        .padding(.bottom, 16)
                        .zIndex(1)
                }
                .background(
                    RoundedRectangle(cornerRadius: 18)
                        .foregroundColor(Color.backgroundColor)
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
}
