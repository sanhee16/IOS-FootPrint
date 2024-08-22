//
//  EditNoteView.swift
//  Footprint
//
//  Created by sandy on 8/10/24.
//

import SwiftUI
import SDSwiftUIPack

struct EditNoteView: View {
    struct Output {
        var pop: () -> ()
    }
    
    enum ViewEventTrigger {
        case pop
    }
    
    private var output: Output
    
    private let location: Location
    private let type: EditFootprintType
    
    @StateObject var vm: EditNoteVM = EditNoteVM()
    
    init(output: Output, location: Location, type: EditFootprintType) {
        self.output = output
        self.location = location
        self.type = type
    }
    
    private var safeTop: CGFloat { get { Util.safeTop() }}
    private var safeBottom: CGFloat { get { Util.safeBottom() }}
    private let IMAGE_SIZE: CGFloat = 70.0
    
    @State private var isPresentCategoryList: Bool = false
    @State private var isPresentCalendar: Bool = false
    
    private let CALENDAR_ID: String = "CALENDAR_ID"
    private let LOCATION_ID: String = "LOCATION_ID"
    
    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .leading, spacing: 0) {
                drawHeader(geometry)
                ScrollViewReader { scrollProxy in
                    ScrollView(showsIndicators: false) {
                        VStack(alignment: .leading, spacing: 10) {
                            drawTitle("제목", isEssential: true)
                                .onTapGesture {
                                    $vm.address.wrappedValue = "Random - \(Int.random(in: 0..<100))"
                                }
                            FPTextField(placeHolder: "title".localized(), text: $vm.title, fieldStyle: .line, lineStyle: .single(limit: nil))
                            
                            drawTitle("내용", isEssential: false)
                                .sdPaddingTop(24)
                            FPTextField(placeHolder: "content".localized(), text: $vm.content, fieldStyle: .line, lineStyle: .multi(limit: nil))
                            
                            drawTitle("위치", isEssential: true)
                                .sdPaddingTop(24)
                            FPTextField(placeHolder: "".localized(), text: $vm.address, fieldStyle: .none, lineStyle: .multi(limit: nil), isDisabled: true)
                            
                            FPButton(text: "발자국 위치 확인하기", status: .able, size: .large, type: .lightSolid) {
                                
                            }
                            .sdPaddingVertical(8)
                            .id(LOCATION_ID)
                            
                            //                        drawDateArea(geometry)
                            //                        drawCategorySelectArea(geometry)
                            //                        drawPeopleWithArea(geometry)
                            //                        drawImageArea(geometry)
                            
                            Divider()
                                .background(Color.dim_black_low)
                                .sdPaddingVertical(8)
                            
                            
                            HStack(alignment: .center, spacing: 0, content: {
                                drawTitle("날짜", isEssential: true)
                                    .frame(width: 100, height: 40, alignment: .leading)
                                Text("\($vm.createdAt.wrappedValue.toEditNoteDate)")
                            })
                            .id(CALENDAR_ID)
                            .contentShape(Rectangle())
                            .onTapGesture {
                                scrollProxy.scrollTo(LOCATION_ID, anchor: .top)
                                isPresentCalendar.toggle()
                            }
                            .sheet(isPresented: $isPresentCalendar, onDismiss: {
                                scrollProxy.scrollTo(CALENDAR_ID, anchor: .center)
                            }, content: {
                                VStack(alignment: .leading, spacing: 0) {
                                    HStack(alignment: .center, spacing: 0) {
                                        Text("날짜")
                                        Spacer()
                                        FPButton(text: "오늘", status: .able, size: .small, type: .textGray) {
                                            $vm.createdAt.wrappedValue = Date()
                                        }
                                        FPButton(text: "완료", status: .able, size: .small, type: .textGray) {
                                            $isPresentCalendar.wrappedValue = false
                                        }
                                    }
                                    .sdPaddingHorizontal(24)
                                    .sdPaddingTop(26)
                                    
                                    DatePicker(
                                        "",
                                        selection: $vm.createdAt,
                                        displayedComponents: [.date]
                                    )
                                    .padding()
                                    .datePickerStyle(.graphical)
                                    .labelsHidden()
                                    .frame(height: 400)
                                    
                                    Spacer()
                                }
                                .presentationDetents([.height(470), .large])
                                .presentationDragIndicator(.visible)
                            })
                            
                            HStack(alignment: .center, spacing: 0, content: {
                                drawTitle("카테고리", isEssential: true)
                                    .frame(width: 100, height: 40, alignment: .leading)
                                
                            })
                            
                            //                        MultilineTextField("content".localized(), text: $vm.content) {
                            //
                            //                        }
                            //                        .frame(minHeight: 300.0, alignment: .topLeading)
                            //                        .padding(EdgeInsets(top: 12, leading: 10, bottom: 12, trailing: 10))
                            //                        .contentShape(Rectangle())
                            //                        .background(
                            //                            RoundedRectangle(cornerRadius: 2)
                            //                                .foregroundColor(.inputBoxColor)
                            //                        )
                            //                        .onChange(of: $vm.content.wrappedValue) { value in
                            //                            if value == " " {
                            //                                $vm.content.wrappedValue = ""
                            //                            }
                            //                        }
                        }
                        .sdPaddingHorizontal(16)
                        .sdPaddingVertical(14)
                    }
                    
                }
                .sheet(isPresented: $isPresentCategoryList, onDismiss: {
                    
                }, content: {
                    
                })
                .onChange(of: $vm.address.wrappedValue, perform: { value in
                    print("[SD] \(value)")
                })
                .padding(EdgeInsets(top: safeTop, leading: 0, bottom: 0, trailing: 0))
                .ignoresSafeArea(.container, edges: [.top, .bottom])
                .frame(width: geometry.size.width, alignment: .leading)
                .toolbar {
                    ToolbarItemGroup(placement: .keyboard) {
                        Spacer() // Spacer to push button to the right
                        Button("Done") {
                            UIApplication.shared.hideKeyborad()
                        }
                    }
                }
                
                HStack(alignment: .center, spacing: 8, content: {
                    HStack(alignment: .center, spacing: 8, content: {
                        Image("picture")
                            .resizable()
                            .scaledToFit()
                            .frame(both: 16, alignment: .center)
                        Text("사진")
                            .sdFont(.btn3, color: .btn_lightSolid_cont_default)
                    })
                    .padding(8)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        
                    }
                    
                    HStack(alignment: .center, spacing: 8, content: {
                        Image("user-add")
                            .resizable()
                            .scaledToFit()
                            .frame(both: 16, alignment: .center)
                        Text("함께한 사람")
                            .sdFont(.btn3, color: .btn_lightSolid_cont_default)
                    })
                    .padding(8)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        
                    }
                    Spacer()
                })
                .sdPaddingVertical(4)
                .sdPaddingHorizontal(16)
                .frame(width: UIScreen.main.bounds.width)
                .background(Color.bg_bgb)
            }
            .background(Color.white)
        }
        .background(Color.bg_bgb)
        .navigationBarBackButtonHidden()
        .onAppear {
            vm.setValue(location: self.location, type: self.type) { eventTrigger in
                switch eventTrigger {
                case .pop:
                    self.output.pop()
                }
            }
            vm.onAppear()
        }
    }
    
    private func drawHeader(_ geometry: GeometryProxy) -> some View {
        return ZStack(alignment: .leading) {
            Topbar("발자국 남기기", type: .back) {
                vm.onClickSave()
            }
            HStack(alignment: .center, spacing: 12) {
                Spacer()
                Image($vm.isStar.wrappedValue ? "star_on" : "star_off")
                    .resizable()
                    .scaledToFit()
                    .frame(both: 20.0, alignment: .center)
                    .onTapGesture {
                        $vm.isStar.wrappedValue = !$vm.isStar.wrappedValue
                    }
                FPButton(text: "완료", status: .disable, size: .small, type: .textPrimary) {
                    vm.saveNote()
                }
//                if case let .modify(item) = vm.type {
//                    Text("delete".localized())
//                        .menuText()
//                        .onTapGesture {
//                            vm.onClickDelete(item.id)
//                        }
//                }
            }
            .menuView()
        }
        .frame(width: geometry.size.width, height: 50, alignment: .center)
    }
    
    private func drawTitle(_ text: String, isEssential: Bool) -> some View {
        HStack(alignment: .center, spacing: 4, content: {
            Text(text)
                .sdFont(.headline3, color: .black)
            Text(isEssential ? "*" : "")
                .sdFont(.headline3, color: .blue)
        })
    }
    
    private func drawDateArea(_ geometry: GeometryProxy) -> some View {
        return HStack(alignment: .center, spacing: 0) {
            Text("date".localized())
                .font(.kr13b)
                .foregroundColor(.gray90)
            Spacer()
            DatePicker(
                "",
                selection: $vm.createdAt,
                displayedComponents: [.date]
            )
            .labelsHidden()
        }
        .padding(EdgeInsets(top: 10, leading: 18, bottom: 6, trailing: 16))
    }
    
    private func drawImageArea(_ geometry: GeometryProxy) -> some View {
        return VStack(alignment: .leading, spacing: 4) {
            Text("image".localized())
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
                            .shadow(color: Color.black.opacity(0.3), radius: 2, x: 0.5, y: 0.5)
                    }
                    Text("+")
                        .font(.kr16b)
                        .foregroundColor(.white)
                        .frame(both: IMAGE_SIZE, alignment: .center)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .foregroundColor(.textColor3)
                        )
                        .onTapGesture {
                            vm.onClickGallery()
                        }
                }
                .padding(EdgeInsets(top: 3, leading: 16, bottom: 8, trailing: 16))
            }
        }
    }
    
    private func drawPeopleWithArea(_ geometry: GeometryProxy) -> some View {
        return VStack(alignment: .leading, spacing: 4) {
            HStack(alignment: .center, spacing: 10) {
                Text("people_with".localized())
                    .font(.kr13b)
                    .foregroundColor(.gray90)
                Spacer()
                Text("add".localized())
                    .font(.kr12r)
                    .foregroundColor(.gray60)
                    .onTapGesture {
                        vm.onClickAddPeopleWith()
                    }
            }
            .padding(EdgeInsets(top: 10, leading: 18, bottom: 6, trailing: 12))
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(alignment: .center, spacing: 12) {
                    ForEach($vm.peopleWith.wrappedValue, id: \.self) { item in
                        Text(item.name)
                            .font(.kr11r)
                            .foregroundColor(.textColor1)
                    }
                }
                .padding(EdgeInsets(top: 6, leading: 18, bottom: 6, trailing: 18))
            }
        }
    }
    
    private func drawCategorySelectArea(_ geometry: GeometryProxy) -> some View {
        return VStack(alignment: .leading, spacing: 4) {
            HStack(alignment: .center, spacing: 10) {
                Text("category".localized())
                    .font(.kr13b)
                    .foregroundColor(.gray90)
                Spacer()
                Text("select".localized())
                    .font(.kr12r)
                    .foregroundColor(.gray60)
                    .onTapGesture {
                        vm.onClickSelectCategory()
                    }
            }
            .padding(EdgeInsets(top: 10, leading: 18, bottom: 6, trailing: 12))
            categoryItem($vm.category.wrappedValue)
                .padding(EdgeInsets(top: 6, leading: 18, bottom: 6, trailing: 12))
        }
    }
    
    private func categoryItem(_ item: Category) -> some View {
        return HStack(alignment: .center, spacing: 6) {
            Image(item.pinType.pinType().pinWhite)
                .resizable()
                .frame(both: 14.0, alignment: .center)
                .colorMultiply(Color(hex: item.pinColor.pinColor().pinColorHex))
            Text(item.name)
                .font(.kr11r)
                .foregroundColor(.textColor1)
        }
    }
}
