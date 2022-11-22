//
//  AddFootprintView.swift
//  Footprint
//
//  Created by Studio-SJ on 2022/11/04.
//

import SwiftUI

struct AddFootprintView: View, KeyboardReadable {
    typealias VM = AddFootprintViewModel
    public static func vc(_ coordinator: AppCoordinator, location: Location, completion: (()-> Void)? = nil) -> UIViewController {
        let vm = VM.init(coordinator, location: location)
        let view = Self.init(vm: vm)
        let vc = BaseViewController(view, completion: completion)
        return vc
    }
    @ObservedObject var vm: VM
    
    private var safeTop: CGFloat { get { Util.safeTop() }}
    private var safeBottom: CGFloat { get { Util.safeBottom() }}
    
    private let IMAGE_SIZE: CGFloat = 70.0
    
    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .leading, spacing: 0) {
                drawHeader(geometry)
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 10) {
                        TextField("enter title", text: $vm.title)
                            .padding(EdgeInsets(top: 10, leading: 8, bottom: 10, trailing: 8))
                            .background(
                                RoundedRectangle(cornerRadius: 6)
                                    .foregroundColor(.greenTint5)
                            )
                            .contentShape(Rectangle())
                            .padding([.leading, .trailing], 16)
                        drawPinSelectArea(geometry)
                        drawCategorySelectArea(geometry)
                        drawImageArea(geometry)
                        
                        Divider()
                            .background(Color.greenTint5)
                            .padding(EdgeInsets(top: 4, leading: 16, bottom: 4, trailing: 16))
                        
                        MultilineTextField("enter content", text: $vm.content) {
                            
                        }
                        .frame(minHeight: 300.0, alignment: .topLeading)
                        .padding(EdgeInsets(top: 12, leading: 10, bottom: 12, trailing: 10))
                        .contentShape(Rectangle())
                        .background(
                            RoundedRectangle(cornerRadius: 2)
                                .foregroundColor(.greenTint5)
                        )
                        .onReceive(keyboardPublisher) { newIsKeyboardVisible in
                            $vm.isKeyboardVisible.wrappedValue = newIsKeyboardVisible
                        }
                        .onChange(of: $vm.content.wrappedValue) { value in
                            if value == " " {
                                $vm.content.wrappedValue = ""
                            }
                        }
                        .padding([.leading, .trailing], 16)
                    }
                    .padding([.top, .bottom], 14)
                }
                Spacer()
            }
            .padding(EdgeInsets(top: safeTop, leading: 0, bottom: $vm.isKeyboardVisible.wrappedValue ? 0 : safeBottom, trailing: 0))
            .ignoresSafeArea(.container, edges: [.top, .bottom])
            .frame(width: geometry.size.width, alignment: .leading)
        }
        .onAppear {
            vm.onAppear()
        }
    }
    
    private func drawHeader(_ geometry: GeometryProxy) -> some View {
        return ZStack(alignment: .leading) {
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
            .frame(width: geometry.size.width - 32, height: 50, alignment: .center)
        }
        .frame(width: geometry.size.width, height: 50, alignment: .center)
    }
    
    private func drawImageArea(_ geometry: GeometryProxy) -> some View {
        return VStack(alignment: .leading, spacing: 4) {
            Text("이미지 선택")
                .font(.kr13b)
                .foregroundColor(.gray90)
                .padding(EdgeInsets(top: 10, leading: 18, bottom: 6, trailing: 12))
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
                                .foregroundColor(.gray30)
                        )
                        .onTapGesture {
                            vm.onClickGallery()
                        }
                }
                .padding([.leading, .trailing], 16)
            }
        }
    }
    
    
    private func drawPinSelectArea(_ geometry: GeometryProxy) -> some View {
        return VStack(alignment: .leading, spacing: 4) {
            Text("pin 선택")
                .font(.kr13b)
                .foregroundColor(.gray90)
                .padding(EdgeInsets(top: 10, leading: 18, bottom: 6, trailing: 12))
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(alignment: .center, spacing: 12) {
                    ForEach($vm.pinList.wrappedValue, id: \.self) { item in
                        pinItem(item, isSelected: $vm.pinType.wrappedValue == item)
                    }
                }
                .padding(EdgeInsets(top: 6, leading: 12, bottom: 6, trailing: 12))
            }
        }
    }
    
    private func drawCategorySelectArea(_ geometry: GeometryProxy) -> some View {
        return VStack(alignment: .leading, spacing: 4) {
            HStack(alignment: .center, spacing: 10) {
                Text("카테고리 선택")
                    .font(.kr13b)
                    .foregroundColor(.gray90)
                Spacer()
                Text($vm.isCategoryEditMode.wrappedValue ? "편집 종료" : "카테고리 편집")
                    .font(.kr12r)
                    .foregroundColor(.gray60)
                    .onTapGesture {
                        vm.onClickEditCategory()
                    }
                Text("카테고리 추가")
                    .font(.kr12r)
                    .foregroundColor(.gray60)
                    .onTapGesture {
                        vm.onClickAddCategory()
                    }
            }
            .padding(EdgeInsets(top: 10, leading: 18, bottom: 6, trailing: 12))
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(alignment: .center, spacing: 12) {
                    ForEach($vm.categories.wrappedValue, id: \.self) { item in
                        categoryItem(item, isSelected: $vm.category.wrappedValue == item)
                    }
                }
                .padding(EdgeInsets(top: 6, leading: 12, bottom: 6, trailing: 12))
            }
        }
    }
    
    private func categoryItem(_ item: Category, isSelected: Bool) -> some View {
        return ZStack(alignment: .topTrailing) {
            Text(item.name)
                .font(isSelected ? .kr11b : .kr11r)
                .foregroundColor(isSelected ? Color.gray90 : Color.gray60)
                .padding(EdgeInsets(top: 6, leading: 8, bottom: 6, trailing: 8))
                .border(isSelected || $vm.isCategoryEditMode.wrappedValue ? .greenTint4 : .clear, lineWidth: 2, cornerRadius: 6)
                .onTapGesture {
                    if $vm.isCategoryEditMode.wrappedValue {
                        if item.tag != -1 {
                            vm.editCategory(item)
                        }
                    } else {
                        vm.onSelectCategory(item)
                    }
                }
                .padding([.top, .trailing], 5)
        }
    }
    
    private func pinItem(_ item: PinType, isSelected: Bool) -> some View {
        return Image(item.pinName)
            .resizable()
            .scaledToFit()
            .frame(both: 30)
            .padding(10)
            .border(isSelected ? .greenTint4 : .clear, lineWidth: 2, cornerRadius: 12)
            .onTapGesture {
                vm.onSelectPin(item)
            }
    }
}
