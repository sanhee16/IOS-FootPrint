//
//  MemberEditView.swift
//  Footprint
//
//  Created by sandy on 8/24/24.
//

import Foundation
import SwiftUI
import SDSwiftUIPack
import Photos
import PhotosUI

struct MemberEditView: View {
    @EnvironmentObject var vm: MemberEditVM
    @Binding var isPresented: Bool
    
    var body: some View {
        ZStack(content: {
            Color.bg_default
            VStack(alignment: .leading, spacing: 0, content: {
                drawHeader()
                
                VStack(alignment: .leading, spacing: 0, content: {
                    drawTitle("사진", isEssential: false)
                    PhotosPicker(
                        selection: $vm.selectedPhoto,
                        matching: .images,
                        photoLibrary: .shared()
                    ) {
                        HStack(alignment: .center, spacing: 0, content: {
                            Spacer()
                            if let image = vm.image {
                                Image(uiImage: image)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(both: 80.0, alignment: .center)
                                    .clipShape(Circle())
                                    .contentShape(Rectangle())
                            } else {
                                Image("profile 1")
                                    .resizable()
                                    .frame(both: 80.0, alignment: .center)
                                    .clipShape(Circle())
                                    .contentShape(Rectangle())
                            }
                            Spacer()
                        })
                        .sdPaddingVertical(8)
                    }
                    .onChange(of: vm.selectedPhoto, perform: { value in
                        vm.selectImage()
                    })
                    
                    drawTitle("이름", isEssential: true)
                    FPTextField(placeHolder: "name".localized(), text: $vm.name, fieldStyle: .line, lineStyle: .single(limit: nil))
                        .ignoresSafeArea(.keyboard)
                    
                    drawTitle("설명", isEssential: false)
                    FPTextField(placeHolder: "intro".localized(), text: $vm.intro, fieldStyle: .line, lineStyle: .single(limit: nil))
                        .ignoresSafeArea(.keyboard)
                    Spacer()
                })
                .sdPaddingHorizontal(16)
            })
        })
        .onTapGesture {
            hideKeyboard()
        }
    }
    
    private func colorItem(_ hexColor: String) -> some View {
        Circle()
            .frame(both: 24.0, alignment: .center)
            .foregroundStyle(Color(hex: hexColor))
    }
    
    private func iconItem(_ iconName: String) -> some View {
        Image(iconName)
            .frame(both: 24.0, alignment: .center)
    }
    
    private func drawHeader() -> some View {
        HStack(alignment: .center, spacing: 0) {
            FPButton(text: "취소", status: .able, size: .small, type: .textGray) {
                $isPresented.wrappedValue = false
            }
            Spacer()
            Text(vm.type.title)
            Spacer()
            FPButton(text: "완료", status: $vm.isAvailableToSave.wrappedValue ? .able : .disable, size: .small, type: .textGray) {
                vm.saveMember {
                    isPresented = false
                }
            }
        }
        .sdPaddingHorizontal(24)
        .sdPaddingTop(26)
    }
    
    private func drawTitle(_ text: String, isEssential: Bool) -> some View {
        HStack(alignment: .center, spacing: 4, content: {
            Text(text)
                .sdFont(.headline3, color: .black)
            Text(isEssential ? "*" : "")
                .sdFont(.headline3, color: .blue)
        })
        .sdPaddingTop(24)
    }
}
