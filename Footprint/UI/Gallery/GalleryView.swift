//
//  GalleryView.swift
//  Footprint
//
//  Created by Studio-SJ on 2022/11/04.
//


import SwiftUI
import SwiftUIPullToRefresh
import Kingfisher

struct GalleryView: View {
    typealias VM = GalleryViewModel
    public static func vc(_ coordinator: AppCoordinator, onClickItem: ((GalleryItem)->())?, completion: (()-> Void)? = nil) -> UIViewController {
        let vm = VM.init(coordinator, onClickItem: onClickItem)
        let view = Self.init(vm: vm)
        let vc = BaseViewController.init(view, completion: completion)
        return vc
    }
    @ObservedObject var vm: VM
    
    private var safeTop: CGFloat { get { Util.safeTop() }}
    private var safeBottom: CGFloat { get { Util.safeBottom() }}
    
    
    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .center, spacing: 0) {
                Topbar("gallery", type: .close) {
                    vm.onClose()
                }
                
                if $vm.isFirstLoading.wrappedValue {
                    Spacer()
                    ProgressView()
                    Spacer()
                } else {
                    RefreshableScrollView(onRefresh: { done in
                        vm.loadAllImages {
                            done()
                        }
                    }) {
                        ZStack(alignment: .bottom) {
                            VStack(alignment: .center, spacing: 0) {
                                if $vm.items.wrappedValue.isEmpty {
                                    Spacer()
                                    Text("앨범이 비어있습니다.")
                                        .font(.kr14b)
                                        .foregroundColor(.gray100)
                                    Spacer()
                                } else {
                                    let cellSize = geometry.size.width / 3 - 2
                                    LazyVGrid(columns: Array(repeating: .init(.flexible(), spacing: 1), count: 3), spacing: 1) {
                                        ForEach($vm.items.wrappedValue.indices, id: \.self) { idx in
                                            let item = vm.items[idx]
                                            ZStack(alignment: .topLeading) {
                                                if let selectedImage = $vm.item.wrappedValue {
                                                    Image("selected") //TODO: 이미지 필요함
                                                        .resizable()
                                                        .frame(both: 10)
                                                }
                                                    
                                                Image(uiImage: item.image)
                                                    .resizable()
                                                    .aspectRatio(contentMode: .fill)
                                                    .frame(width: cellSize, height: cellSize)
                                                    .clipped()
                                                    .contentShape(Rectangle())
                                                    .onTapGesture {
                                                        vm.onClickItem(item)
                                                    }
                                                    .onAppear {
                                                        if idx == $vm.items.wrappedValue.count - 1 {
                                                            vm.loadNextImage()
                                                        }
                                                    }
                                            }
                                        }
                                    }
                                    if vm.hasNextPage && !vm.isFirstLoading {
                                        VStack(alignment: .center, spacing: 0) {
                                            ProgressView()
                                        }
                                        .frame(width: geometry.size.width, height: 100, alignment: .center)
                                    }
                                }
                            }
                            .frame(width: geometry.size.width, height: geometry.size.height - 50, alignment: .center)
                            
                            Text("선택하기")
                                .font(.kr16b)
                                .foregroundColor(.white)
                                .frame(width: geometry.size.width - 40, height: 40, alignment: .center)
                                .background(
                                    RoundedRectangle(cornerRadius: 16)
                                        .foregroundColor($vm.item.wrappedValue == nil ? .gray30 : .blue80)
                                )
                                .onTapGesture {
                                    vm.onSelectImage()
                                }
                        }
                        .frame(width: geometry.size.width, height: geometry.size.height - 50, alignment: .center)
                    }
                }
            }
            .padding(EdgeInsets(top: safeTop, leading: 0, bottom: safeBottom, trailing: 0))
            .edgesIgnoringSafeArea(.all)
            .frame(width: geometry.size.width, alignment: .center)
        }
        .onAppear {
            vm.onAppear()
        }
    }
}
