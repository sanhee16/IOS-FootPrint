//
//  AddFootprintView.swift
//  Footprint
//
//  Created by Studio-SJ on 2022/11/04.
//

import SwiftUI

struct AddFootprintView: View {
    typealias VM = AddFootprintViewModel
    public static func vc(_ coordinator: AppCoordinator, location: Location, completion: (()-> Void)? = nil) -> UIViewController {
        let vm = VM.init(coordinator, location: location)
        let view = Self.init(vm: vm)
        let vc = BaseViewController(view, completion: completion)
//        let vc = BaseViewController.bottomSheet(view, sizes: [.fixed(500)])
        return vc
    }
    @ObservedObject var vm: VM
    
    private var safeTop: CGFloat { get { Util.safeTop() }}
    private var safeBottom: CGFloat { get { Util.safeBottom() }}
    
    private let IMAGE_SIZE: CGFloat = 70.0
    
    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .leading, spacing: 0) {
                ZStack(alignment: .leading) {
                    Topbar("", type: .back) {
                        vm.onClose()
                    }
                    HStack(alignment: .center, spacing: 0) {
                        Spacer()
                        Text("저장")
                            .font(.kr12r)
                            .foregroundColor(.gray100)
                            .onTapGesture {
                                vm.onClickSave()
                            }
                    }
                    .padding([.leading, .trailing], 12)
                    .frame(width: geometry.size.width - 24, height: 50, alignment: .center)
                }
                .frame(width: geometry.size.width, height: 50, alignment: .center)
                VStack(alignment: .leading, spacing: 10) {
                    TextField("enter title", text: $vm.title)
                        .padding(EdgeInsets(top: 6, leading: 8, bottom: 6, trailing: 8))
                        .background(Color.gray30) //TODO: remove
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach($vm.images.wrappedValue.indices, id: \.self) { idx in
                                let image = $vm.images.wrappedValue[idx]
                                Image(uiImage: image)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(both: IMAGE_SIZE)
                                    .clipShape(RoundedRectangle(cornerRadius: 12))
                                    .contentShape(Rectangle())
                                    .onTapGesture {
                                        vm.removeImage(image)
                                    }
                            }
                            Text("+")
                                .font(.kr16b)
                                .foregroundColor(.white)
                                .frame(both: IMAGE_SIZE, aligment: .center)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .foregroundColor(.gray60)
                                )
                                .onTapGesture {
                                    vm.onClickGallery()
                                }
                        }
                    }
                    MultilineTextField("enter content", text: $vm.content) {
                        
                    }
                    .padding(EdgeInsets(top: 4, leading: 6, bottom: 4, trailing: 6))
                }
                .padding(EdgeInsets(top: 10, leading: 16, bottom: 10, trailing: 16))
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
