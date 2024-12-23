//
//  CategoryEditView.swift
//  Footprint
//
//  Created by sandy on 8/23/24.
//

import Foundation
import SwiftUI
import SDSwiftUIPack
import SDFlowLayout

struct CategoryEditView: View {
    @EnvironmentObject var vm: CategoryEditVM
    @Binding var isPresented: Bool
    
    var body: some View {
        ZStack(content: {
            Color.bg_default
            VStack(alignment: .leading, spacing: 0, content: {
                drawHeader()
                ScrollView(.vertical, showsIndicators: false, content: {
                    VStack(alignment: .leading, spacing: 0, content: {
                        drawTitle("이름", isEssential: false)
                        
                        FPTextField(placeHolder: "name".localized(), text: $vm.name, fieldStyle: .line, lineStyle: .single(limit: nil))
                            .ignoresSafeArea(.keyboard)
                        
                        Divider()
                        
                        drawTitle("색상", isEssential: false)
                        HStack(alignment: .bottom, spacing: 0, content: {
                            ForEach(vm.DEFAULT_COLORS, id: \.self) { color in
                                ZStack(alignment: .bottomTrailing, content: {
                                    colorItem(color.hex)
                                        .padding(8)
                                        .background(
                                            RoundedRectangle(cornerRadius: 2)
                                                .foregroundStyle($vm.color.wrappedValue == color ? Color.zineGray_200 : Color.clear)
                                        )
                                    if $vm.color.wrappedValue == color {
                                        Image("SelectButton")
                                            .resizable()
                                            .offset(x: 4, y: 4)
                                            .frame(width: 16.0, height: 16.0, alignment: .center)
                                            .zIndex(1)
                                    }
                                })
                                .frame(maxWidth: .infinity)
                                .layoutPriority(.greatestFiniteMagnitude)
                                .contentShape(Rectangle())
                                .onTapGesture {
                                    $vm.color.wrappedValue = color
                                }
                            }
                        })
                        .sdPaddingVertical(16)
                        
                        drawTitle("아이콘", isEssential: false)
                            .sdFont(.headline3, color: Color.zineGray_700)
                        
                        Text("감정")
                            .sdFont(.headline4, color: Color.zineGray_700)
                            .sdPaddingTop(24)
                        SDFlowLayout(data: vm.emotionIcons, id: \.self) { icon in
                            iconItem(icon)
                        }
                        .sdPaddingVertical(16)
                        
                        Text("일상")
                            .sdFont(.headline4, color: Color.zineGray_700)
                            .sdPaddingTop(24)
                        SDFlowLayout(data: vm.dailyIcons, id: \.self) { icon in
                            iconItem(icon)
                        }
                        .sdPaddingVertical(16)
                        
                        Text("활동")
                            .sdFont(.headline4, color: Color.zineGray_700)
                            .sdPaddingTop(24)
                        SDFlowLayout(data: vm.activityIcons, id: \.self) { icon in
                            iconItem(icon)
                        }
                        .sdPaddingVertical(16)
                        
                        Text("자연")
                            .sdFont(.headline4, color: Color.zineGray_700)
                            .sdPaddingTop(24)
                        SDFlowLayout(data: vm.natureIcons, id: \.self) { icon in
                            iconItem(icon)
                        }
                        .sdPaddingVertical(16)
                        
                        Text("기타")
                            .sdFont(.headline4, color: Color.zineGray_700)
                            .sdPaddingTop(24)
                        SDFlowLayout(data: vm.etcIcons, id: \.self) { icon in
                            iconItem(icon)
                        }
                        .sdPaddingTop(16)
                    })
                    .sdPaddingHorizontal(16)
                    .sdPaddingBottom(40)
                })
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
    
    private func iconItem(_ icon: CategoryIcon) -> some View {
        ZStack(alignment: .bottomTrailing,
               content: {
            Image(icon.imageName)
                .renderingMode(.template)
                .foregroundColor(
                    $vm.color.wrappedValue == nil ? Color.btn_ic_cont_disable : Color(hex: $vm.color.wrappedValue!.hex)
                )
                .frame(both: 24.0, alignment: .center)
                .padding(10)
                .background(
                    RoundedRectangle(cornerRadius: 2)
                        .foregroundStyle($vm.icon.wrappedValue == icon ? Color.zineGray_200 : Color.clear)
                )
            if $vm.icon.wrappedValue == icon {
                Image("SelectButton")
                    .resizable()
                    .offset(x: 4, y: 4)
                    .frame(width: 16.0, height: 16.0, alignment: .center)
                    .zIndex(1)
            }
        })
        .frame(width: (UIScreen.main.bounds.width - 32.0) / CGFloat(vm.CHUNK_SIZE), alignment: .center)
        .contentShape(Rectangle())
        .onTapGesture {
            $vm.icon.wrappedValue = icon
        }
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
                vm.saveCategory {
                    $isPresented.wrappedValue = false
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
