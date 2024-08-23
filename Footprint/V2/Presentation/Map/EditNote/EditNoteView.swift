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
        var pushCategoryListEditView: () -> ()
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
    private let CATEGORY_ID: String = "CATEGORY_ID"
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
                                vm.saveTempStorage()
                                self.output.pop()
                            }
                            .sdPaddingVertical(8)
                            .id(LOCATION_ID)
                            
                            Divider()
                                .background(Color.dim_black_low)
                                .sdPaddingVertical(8)
                            
                            drawDate(scrollProxy: scrollProxy)
                            drawCategory(scrollProxy: scrollProxy)
                            
                        }
                        .sdPaddingHorizontal(16)
                        .sdPaddingVertical(14)
                    }
                    
                }
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
        }
    }
    
    private func drawCategory(scrollProxy: ScrollViewProxy) -> some View {
        HStack(alignment: .center, spacing: 0, content: {
            drawTitle("카테고리", isEssential: true)
                .frame(width: 100, height: 40, alignment: .leading)
            if let selectedCategory = $vm.category.wrappedValue {
                categoryItem(selectedCategory)
            }
            
            Spacer()
        })
        .id(CATEGORY_ID)
        .onTapGesture {
            scrollProxy.scrollTo(LOCATION_ID, anchor: .top)
            $isPresentCategoryList.wrappedValue = true
        }
        .sheet(isPresented: $isPresentCategoryList, onDismiss: {
            scrollProxy.scrollTo(CALENDAR_ID, anchor: .center)
        }, content: {
            VStack(alignment: .leading, spacing: 0, content: {
                HStack(alignment: .center, spacing: 0) {
                    Text("카테고리")
                    Spacer()
                    FPButton(text: "편집", status: .able, size: .small, type: .textGray) {
                        $isPresentCategoryList.wrappedValue = false
                        output.pushCategoryListEditView()
                    }
                    FPButton(text: "완료", status: .able, size: .small, type: .textGray) {
                        $isPresentCategoryList.wrappedValue = false
                    }
                }
                .sdPaddingHorizontal(24)
                .sdPaddingTop(26)
                
                ScrollView(.vertical, showsIndicators: false, content: {
                    ForEach($vm.categories.wrappedValue, id: \.self) { item in
                        HStack(alignment: .center, spacing: 0, content: {
                            categoryItem(item)
                            Spacer()
                            if let selectedCategory = $vm.category.wrappedValue, selectedCategory == item {
                                Image("SelectButton")
                                    .resizable()
                                    .frame(width: 16.0, height: 16.0, alignment: .center)
                            }
                        })
                        .padding(16)
                        .contentShape(Rectangle())
                        .onTapGesture {
                            $vm.category.wrappedValue = item
                        }
                    }
                    .sdPaddingBottom(20)
                })
            })
            .presentationDetents([.medium, .large])
        })
    }
    
    private func drawDate(scrollProxy: ScrollViewProxy) -> some View {
        HStack(alignment: .center, spacing: 0, content: {
            drawTitle("날짜", isEssential: true)
                .frame(width: 100, height: 40, alignment: .leading)
            Text("\($vm.createdAt.wrappedValue.toEditNoteDate)")
            Spacer()
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
    }
    
    private func drawHeader(_ geometry: GeometryProxy) -> some View {
        return ZStack(alignment: .leading) {
            Topbar("발자국 남기기", type: .back) {
                self.output.pop()
                EditNoteTempStorage.clear()
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
                FPButton(text: "완료", status: $vm.isAvailableToSave.wrappedValue ? .able : .disable, size: .small, type: .textPrimary) {
                    vm.saveNote()
                }
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
    
    
    private func categoryItem(_ item: CategoryV2) -> some View {
        return HStack(alignment: .center, spacing: 8) {
            Image(item.icon)
                .resizable()
                .frame(both: 16.0, alignment: .center)
                .colorMultiply(Color(hex: item.color))
                .contrast(3.0)
            Text(item.name)
                .font(.headline3)
                .foregroundColor(Color(hex: item.color))
        }
        .sdPaddingVertical(4)
        .sdPaddingHorizontal(8)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .foregroundStyle(Color(hex: item.color).opacity(0.1))
        )
    }
}
