//
//  ShowImageView.swift
//  Footprint
//
//  Created by sandy on 2022/12/04.
//
import SwiftUI

struct ShowImageView: View {
    typealias VM = ShowImageViewModel
    public static func vc(_ coordinator: AppCoordinator, image: UIImage ,completion: (()-> Void)? = nil) -> UIViewController {
        let vm = VM.init(coordinator, image: image)
        let view = Self.init(vm: vm)
        let vc = BaseViewController.init(view, completion: completion)
        vc.modalPresentationStyle = .overCurrentContext
        vc.view.backgroundColor = UIColor.clear
        vc.controller.view.backgroundColor = UIColor.gray100
        return vc
    }
    @ObservedObject var vm: VM
    
    private var safeTop: CGFloat { get { Util.safeTop() }}
    private var safeBottom: CGFloat { get { Util.safeBottom() }}
    
    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .center, spacing: 0) {
                Topbar("사진 상세보기", type: .closeWhite, textColor: .white) {
                    vm.onClose()
                }
                Image(uiImage: $vm.image.wrappedValue)
                    .resizable()
                    .aspectRatio($vm.image.wrappedValue.size.width / $vm.image.wrappedValue.size.height, contentMode: .fill)
                    .frame(width: geometry.size.width - 140, alignment: .center)
                Spacer()
            }
            .padding(EdgeInsets(top: safeTop, leading: 0, bottom: safeBottom, trailing: 0))
            .edgesIgnoringSafeArea(.all)
            .frame(width: geometry.size.width, alignment: .leading)
        }
        .onAppear {
            vm.onAppear()
        }
    }
}
