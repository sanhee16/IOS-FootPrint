//
//  ShowImageView.swift
//  Footprint
//
//  Created by sandy on 2022/12/04.
//
import SwiftUI
import SDSwiftUIPack
import SwiftUI
import SwiftUIPullToRefresh
import SwiftUIPager

struct ShowImageView: View {
    typealias VM = ShowImageViewModel
    public static func vc(_ coordinator: AppCoordinatorV1, imageIdx: Int, images: [UIImage] ,completion: (()-> Void)? = nil) -> UIViewController {
        let vm = VM.init(coordinator, imageIdx: imageIdx, images: images)
        let view = Self.init(vm: vm)
        let vc = BaseViewController.init(view, completion: completion)
        vc.modalPresentationStyle = .overCurrentContext
        vc.view.backgroundColor = UIColor.clear
        vc.controller.view.backgroundColor = UIColor.textColor1
        return vc
    }
    @ObservedObject var vm: VM
    
    private var safeTop: CGFloat { get { Util.safeTop() }}
    private var safeBottom: CGFloat { get { Util.safeBottom() }}
    
    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .center, spacing: 0) {
                Topbar("detail_image".localized(), type: .closeWhite, textColor: .white) {
                    vm.onClose()
                }
                Pager(page: $vm.page.wrappedValue, data: $vm.images.wrappedValue.indices, id: \.self) { idx in
                    let image = $vm.images.wrappedValue[idx]
                    VStack(alignment: .center, spacing: 0) {
                        Spacer()
                        Image(uiImage: image)
                            .resizable()
                            .aspectRatio(image.size.width / image.size.height, contentMode: .fit)
                            .frame(width: geometry.size.width - 40, alignment: .center)
                        Spacer()
                    }
                }
                .itemSpacing(10)
                .interactive(scale: 0.8)
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
