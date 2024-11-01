//
//  FootprintView.swift
//  Footprint
//
//  Created by sandy on 8/10/24.
//

import Foundation
import SwiftUI
import SwiftUIPager
import SDSwiftUIPack

struct FootprintView: View {
    @EnvironmentObject var vm: FootprintVM
    @Binding var isPresented: Bool
    
    private var safeTop: CGFloat { get { Util.safeTop() }}
    private var safeBottom: CGFloat { get { Util.safeBottom() }}
    
    private let IMAGE_SIZE: CGFloat = 70.0
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            ZStack(content: {
                Topbar("", type: .close, backgroundColor: .white) {
                    $isPresented.wrappedValue = false
                }
                HStack(alignment: .center, spacing: 0, content: {
                    Spacer()
                    Image("ic_star")
                        .renderingMode(.template)
                        .tint($vm.isStar.wrappedValue ? Color.btn_ic_cont_default : Color.btn_ic_cont_disable)
                        .font(.system(size: 20))
                        .contentShape(Rectangle())
                        .onTapGesture {
                            $vm.isStar.wrappedValue.toggle()
                            print("$vm.isStar.wrappedValue: \($vm.isStar.wrappedValue)")
                        }
                    Text("편집")
                        .sdFont(.btn3, color: Color.btn_lightSolid_cont_default)
                        .padding(16)
                        .contentShape(Rectangle())
                        .onTapGesture {
                            
                        }
                })
            })
            .padding(EdgeInsets(top: 10, leading: 8, bottom: 10, trailing: 8))
            if $vm.isFailToLoad.wrappedValue {
                Text("정보 불러오기에 실패했습니다")
            } else {
                ScrollView(.vertical, showsIndicators: false, content: {
                    VStack(alignment: .leading, spacing: 0) {
                        if let note = $vm.footPrint.wrappedValue {
                            Text(note.title)
                                .sdFont(.title, color: .cont_gray_default)
                                .sdPaddingHorizontal(16)
                            
                            if !note.content.isEmpty {
                                Text(note.content)
                                    .sdFont(.body1, color: .cont_gray_default)
                                    .padding(16)
                            }
                            
                            VStack(alignment: .leading, spacing: 0, content: {
                                drawTitle("위치")
                                Text(note.address)
                                    .sdFont(.body1, color: .cont_gray_default)
                                    .sdPaddingTop(16)
                            })
                            .sdPaddingTop(24)
                            .sdPaddingHorizontal(16)
                            
                            HStack(alignment: .center, spacing: 0, content: {
                                drawTitle("날짜")
                                Text(note.createdAt.getDate("yyyy. MM. dd"))
                                    .sdFont(.body1, color: .cont_gray_default)
                            })
                            .sdPaddingTop(24)
                            .sdPaddingHorizontal(16)
                            
                            if let category = note.category {
                                HStack(alignment: .center, spacing: 0, content: {
                                    drawTitle("카테고리")
                                    CategoryItem(item: category)
                                })
                                .sdPaddingTop(24)
                                .sdPaddingHorizontal(16)
                            }
                            
                            if !note.imageUrls.isEmpty {
                                drawTitle("사진")
                                    .sdPaddingTop(24)
                                    .sdPaddingHorizontal(16)
                                ScrollView(.horizontal, showsIndicators: false) {
                                    LazyHStack(alignment: .center, spacing: 16, content: {
                                        ForEach(0..<note.imageUrls.count, id: \.self) { idx in
                                            if let dir = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false), let uiImage = UIImage(contentsOfFile: URL(fileURLWithPath: dir.absoluteString).appendingPathComponent(note.imageUrls[idx]).path) {
                                                Image(uiImage: uiImage)
                                                    .resizable()
                                                    .scaledToFill()
                                                    .frame(both: 80.0, alignment: .center)
                                                    .clipShape(
                                                        Rectangle()
                                                    )
                                            }
                                        }
                                    })
                                    .sdPaddingHorizontal(16)
                                }
                                .frame(height: 80.0)
                            }
                            if let peopleWith = note.peopleWith, !peopleWith.isEmpty {
                                drawTitle("함께한 사람")
                                    .sdPaddingTop(24)
                                    .sdPaddingHorizontal(16)
                                PeopleWithView(members: peopleWith)
                                    .sdPaddingVertical(8)
                                    .sdPaddingHorizontal(16)
                            }
                        }
                    }
                    .sdPaddingBottom(40)
                })
            }
        }
        .onAppear {
            vm.onAppear()
        }
        .navigationBarBackButtonHidden()
    }

    private func drawTitle(_ text: String) -> some View {
        Text(text)
            .sdFont(.headline4, color: .zineGray_700)
            .frame(width: 100, height: 40, alignment: .leading)
    }
}
