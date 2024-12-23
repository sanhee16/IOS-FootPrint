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
    let isEditable: Bool
    
    private var safeTop: CGFloat { get { Util.safeTop() }}
    private var safeBottom: CGFloat { get { Util.safeBottom() }}
    
    private let IMAGE_SIZE: CGFloat = 70.0
    
    struct Output {
        var pushUpdateNoteView: (String) -> ()
        var pushCreateNoteView: (Location, String) -> ()
        var pushFootprintListWtihSameAddressView: (String) -> ()
    }
    
    private var output: Output
    
    init(isPresented: Binding<Bool>, output: Output, isEditable: Bool = true) {
        self._isPresented = isPresented
        self.output = output
        self.isEditable = isEditable
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            if isEditable && (!$vm.isFailToLoad.wrappedValue) {
                ZStack(content: {
                    Topbar("", type: .close, backgroundColor: .white) {
                        $isPresented.wrappedValue = false
                    }
                    
                    HStack(alignment: .center, spacing: 0, content: {
                        Spacer()
                        
                        Button(action: {
                            vm.onToggleStar()
                        }, label: {
                            Image("ic_star")
                                .renderingMode(.template)
                                .foregroundColor($vm.isStar.wrappedValue ? Color.btn_ic_cont_default : Color.btn_ic_cont_disable)
                                .font(.system(size: 20))
                        })
                        
                        FPButton(text: "편집", status: .able, size: .small, type: .textGray) {
                            $isPresented.wrappedValue = false
                            if let id = vm.id {
                                self.output.pushUpdateNoteView(id)
                            }
                        }
                    })
                })
                .padding(EdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 8))
            }
            
            if $vm.isFailToLoad.wrappedValue {
                VStack(alignment: .leading, spacing: 0) {
                    Text("정보 불러오기에 실패했습니다")
                        .sdFont(.headline1, color: Color.black)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .sdPaddingTop(20)
                    Spacer()
                }
            } else {
                ScrollView(.vertical, showsIndicators: false, content: {
                    VStack(alignment: .leading, spacing: 0) {
                        if isEditable {
                            FPButton(text: "여기에 발자국 남기기", location: .leading(name: "ic_feet"), status: .able, size: .large, type: .lightSolid) {
                                $isPresented.wrappedValue = false
                                if let note = $vm.footPrint.wrappedValue {
                                    self.output.pushCreateNoteView(Location(latitude: note.latitude, longitude: note.longitude), note.address)
                                }
                            }
                            .padding(.bottom, 10)
                            .sdPaddingHorizontal(16)
                        }
                        
                        if let note = $vm.footPrint.wrappedValue {
                            Text(note.title)
                                .sdFont(.title, color: .cont_gray_default)
                                .sdPaddingHorizontal(16)
                                .padding(.top, 16)
                                .padding(.bottom, 8)
                            
                            if !note.content.isEmpty {
                                Text(note.content)
                                    .sdFont(.body1, color: .cont_gray_default)
                                    .sdPadding(top: 16, leading: 16, bottom: 8, trailing: 16)
                            }
                            
                            VStack(alignment: .leading, spacing: 0, content: {
                                if isEditable, $vm.isHasMore.wrappedValue {
                                    drawTitleWithButton("위치", buttonText: "이 위치 발자국 전체보기", alignment: .bottomLeading) {
                                        $isPresented.wrappedValue = false
                                        self.output.pushFootprintListWtihSameAddressView(note.address)
                                    }
                                } else {
                                    drawTitle("위치", alignment: .bottomLeading)
                                }
                                Text(note.address)
                                    .sdFont(.body1, color: .cont_gray_default)
                                    .sdPadding(top: 16, leading: 0, bottom: 8, trailing: 16)
                            })
                            .sdPaddingTop(48)
                            .sdPaddingHorizontal(16)
                            
                            HStack(alignment: .center, spacing: 0, content: {
                                drawTitle("날짜")
                                Text(note.createdAt.getDate("yyyy. MM. dd"))
                                    .sdFont(.body1, color: .cont_gray_default)
                            })
                            .sdPaddingHorizontal(16)
                            .sdPaddingVertical(8)
                            
                            HStack(alignment: .center, spacing: 0, content: {
                                drawTitle("카테고리")
                                CategoryItem(item: note.category)
                            })
                            .sdPaddingHorizontal(16)
                            .sdPaddingVertical(8)
                            
                            if !note.imageUrls.isEmpty {
                                drawTitle("사진", alignment: .bottomLeading)
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
                                    .padding(16)
                                }
                                .frame(height: 80.0 + 16 * 2)
                            }
                            if !note.members.isEmpty {
                                VStack(alignment: .leading, spacing: 0, content: {
                                    drawTitle("함께한 사람", alignment: .bottomLeading)
                                    PeopleWithView(members: note.members)
                                        .sdPaddingVertical(16)
                                })
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
    
    private func drawTitle(_ text: String, alignment: Alignment = .leading) -> some View {
        Text(text)
            .sdFont(.headline4, color: .zineGray_700)
            .frame(width: 100, height: 40, alignment: alignment)
    }
    
    private func drawTitleWithButton(_ text: String, buttonText: String, alignment: Alignment = .leading, onTapButton: @escaping () -> ()) -> some View {
        HStack(alignment: .center, spacing: 0, content: {
            Text(text)
                .sdFont(.headline4, color: .zineGray_700)
                .frame(width: 100, height: 40, alignment: alignment)
            Spacer()
            HStack(alignment: .center, spacing: 0, content: {
                Text(buttonText)
                    .sdFont(.headline4, color: .zineGray_700)
                    .lineLimit(1)
                Image("ic_arrow_right")
                    .resizable()
                    .frame(both: 12)
            })
            .frame(height: 40, alignment: alignment)
            .contentShape(Rectangle())
            .onTapGesture {
                onTapButton()
            }
        })
    }
}
