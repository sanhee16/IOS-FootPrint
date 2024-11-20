//
//  EditTripView.swift
//  Footprint
//
//  Created by sandy on 11/14/24.
//

import SwiftUI
import SDSwiftUIPack
import SDFlowLayout

struct EditTripView: View {
    struct Output {
        var pop: () -> ()
        var popToList: () -> ()
    }
    private let output: Output
    @StateObject private var vm: EditTripVM
    @State private var isPresentStartAtCalendar: Bool = false
    @State private var isPresentEndAtCalendar: Bool = false
    @State private var isPresentFootprints: Bool = false
    @State private var isMoveNextCalendar: Bool = false
    @State private var isPresentCreateComplete: Bool = false
    @State private var isPresentDelete: Bool = false
    @State private var isPresentDeleteComplete: Bool = false
    
    private let CALENDAR_ID: String = "CALENDAR_ID"
    private let CONTENT_ID: String = "CONTENT_ID"
    
    init(type: EditTripType, output: Output) {
        _vm = StateObject(wrappedValue: EditTripVM(type: type))
        self.output = output
    }
    
    var body: some View {
        VStack(alignment: .leading,
               spacing: 0,
               content: {
            drawHeader()
            
            ScrollViewReader { scrollProxy in
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 10) {
                        drawTitle("제목", isEssential: true)
                            .sdPaddingTop(24)
                        FPTextField(placeHolder: "title".localized(), text: $vm.title, fieldStyle: .line, lineStyle: .single(limit: nil))
                        
                        
                        drawTitle("내용", isEssential: false)
                            .sdPaddingTop(24)
                        FPTextField(placeHolder: "content".localized(), text: $vm.content, fieldStyle: .line, lineStyle: .multi(limit: nil))
                            .id(CONTENT_ID)
                        
                        
                        drawTitle("기간", isEssential: true)
                            .sdPaddingTop(24)
                        drawPeriod(scrollProxy: scrollProxy)
                        
                        Rectangle()
                            .frame(maxWidth: .infinity, idealHeight: 0.25)
                            .foregroundStyle(Color.dim_black_low.opacity(0.15))
                        
                        drawTitle("발자취 컨셉", isEssential: true)
                            .sdPaddingTop(24)
                        if let icon = $vm.icon.wrappedValue {
                            TripIconItem(item: icon)
                                .padding(8)
                        }
                        
                        VStack(alignment: .leading,
                               spacing: 0,
                               content: {
                            SDFlowLayout(data: $vm.icons.wrappedValue, id: \.self) { icon in
                                iconItem(icon)
                                    .sdPaddingBottom(8)
                            }
                            
                            if $vm.isExpanded.wrappedValue {
                                FPButton(
                                    text: "컨셉 목록 숨기기",
                                    location: .trailing(name: "ic_arrow_up"),
                                    status: .able,
                                    size: .small,
                                    type: .textGray
                                ) {
                                    vm.toggleExpandIcon()
                                }
                                .sdPaddingVertical(12)
                                .frame(maxWidth: .infinity, alignment: .center)
                            } else {
                                FPButton(
                                    text: "컨셉 목록 전체보기",
                                    location: .trailing(name: "ic_arrow_down"),
                                    status: .able,
                                    size: .small,
                                    type: .textGray
                                ) {
                                    vm.toggleExpandIcon()
                                }
                                .sdPaddingVertical(12)
                                .frame(maxWidth: .infinity, alignment: .center)
                            }
                        })
                        .sdPaddingVertical(16)
                        
                        HStack(alignment: .center, spacing: 0, content: {
                            drawTitle("발자국 모음", isEssential: true)
                            Spacer()
                            if !$vm.footprints.wrappedValue.filter({ $0.idx != nil }).isEmpty {
                                FPButton(text: "편집", status: .able, size: .small, type: .textGray) {
                                    $isPresentFootprints.wrappedValue = true
                                    vm.originalFootprints = $vm.footprints.wrappedValue
                                }
                            }
                        })
                        .sdPaddingTop(24)
                        if $vm.footprints.wrappedValue.filter({ $0.idx != nil }).isEmpty {
                            FPButton(text: "발자국 추가하기", status: .able, size: .large, type: .lightSolid) {
                                $isPresentFootprints.wrappedValue = true
                                vm.originalFootprints = $vm.footprints.wrappedValue
                            }
                            .sdPaddingVertical(8)
                        } else {
                            ForEach($vm.selectedFootprints.wrappedValue, id: \.self) { item in
                                FootprintItem(item: item)
                            }
                        }
                        
                        VStack{}
                            .alert(isPresented: $isPresentDelete) {
                                Alert(
                                    title: Text("발자취 삭제하기"),
                                    message: Text("삭제한 발자취는 복구할 수 없습니다.\n‘\($vm.title.wrappedValue)’를 삭제하시겠습니까?\n(발자국은 삭제되지 않습니다.)"),
                                    primaryButton: .default(Text("취소"), action: {
                                        
                                    }),
                                    secondaryButton: .default(Text("삭제"), action: {
                                        vm.onDelete {
                                            DispatchQueue.main.async {
                                                $isPresentDeleteComplete.wrappedValue = true
                                            }
                                        }
                                    })
                                )
                            }
                        
                        VStack{}
                            .alert(isPresented: $isPresentDeleteComplete) {
                                Alert(
                                    title: Text("삭제 완료"),
                                    message: Text("‘\($vm.title.wrappedValue)’가 삭제 되었습니다."),
                                    dismissButton: .default(Text("확인"), action: {
                                        self.output.popToList()
                                    })
                                )
                            }
                        
                        VStack{}
                            .alert(isPresented: $isPresentCreateComplete) {
                                Alert(
                                    title: Text("발자취 만들기 성공"),
                                    message: Text("‘\($vm.title.wrappedValue)’ 발자취를 만들었어요."),
                                    dismissButton: .default(Text("확인"), action: {
                                        self.output.pop()
                                    })
                                )
                            }
                    }
                    .sdPaddingVertical(4)
                    .sdPaddingHorizontal(16)
                    .background(Color.bg_default)
                }
                .ignoresSafeArea(.keyboard, edges: [.bottom])
            }
        })
        .background(Color.bg_bgb)
        .navigationBarBackButtonHidden()
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .sheet(isPresented: $isPresentFootprints, onDismiss: {
            vm.setSelectedFootprints()
        }, content: {
            SelectFootprintsViewV2(
                isPresented: $isPresentFootprints,
                originalFootprints: vm.originalFootprints
            )
            .environmentObject(vm)
            .presentationDetents([.large])
        })
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                Spacer() // Spacer to push button to the right
                Button(action: {
                    UIApplication.shared.hideKeyborad()
                }, label: {
                    Image("ic_keyboardOff")
                })
            }
        }
        .toolbar(.hidden, for: .tabBar)
    }
    
    private func drawPeriod(scrollProxy: ScrollViewProxy) -> some View {
        HStack(alignment: .center,
               spacing: 0,
               content: {
            Text("\(($vm.startAt.wrappedValue).toEditNoteDate)")
                .sdFont(.btn3, color: $vm.startAtStatus.wrappedValue.textColor)
                .contentShape(Rectangle())
                .onTapGesture {
                    scrollProxy.scrollTo(CONTENT_ID, anchor: .top)
                    $isPresentStartAtCalendar.wrappedValue = true
                    $vm.startAtStatus.wrappedValue = .selecting
                }
                .sheet(isPresented: $isPresentStartAtCalendar, onDismiss: {
                    $vm.startAtStatus.wrappedValue = .selected
                    
                    if $isMoveNextCalendar.wrappedValue {
                        $isMoveNextCalendar.wrappedValue = false
                        $isPresentEndAtCalendar.wrappedValue = true
                        $vm.endAtStatus.wrappedValue = .selecting
                    } else {
                        scrollProxy.scrollTo(CALENDAR_ID, anchor: .center)
                    }
                }, content: {
                    VStack(alignment: .leading, spacing: 0) {
                        HStack(alignment: .center, spacing: 0) {
                            Text("기간: 시작일")
                                .sdFont(.headline2, color: Color.blackGray_900)
                            Spacer()
                            FPButton(text: "오늘", status: .able, size: .small, type: .textGray) {
                                $vm.startAt.wrappedValue = Date()
                            }
                            FPButton(text: "다음", status: .able, size: .small, type: .textGray) {
                                $isMoveNextCalendar.wrappedValue = true
                                $isPresentStartAtCalendar.wrappedValue = false
                            }
                        }
                        .sdPaddingHorizontal(24)
                        .sdPaddingTop(26)
                        
                        DatePicker(
                            "",
                            selection: $vm.startAt,
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
            Spacer()
            Text("~")
            Spacer()
            Text("\(($vm.endAt.wrappedValue).toEditNoteDate)")
                .sdFont(.btn3, color: $vm.endAtStatus.wrappedValue.textColor)
                .contentShape(Rectangle())
                .onTapGesture {
                    scrollProxy.scrollTo(CONTENT_ID, anchor: .top)
                    $isPresentEndAtCalendar.wrappedValue = true
                    $vm.endAtStatus.wrappedValue = .selecting
                }
                .sheet(isPresented: $isPresentEndAtCalendar,
                       onDismiss: {
                    scrollProxy.scrollTo(CALENDAR_ID, anchor: .center)
                    $isMoveNextCalendar.wrappedValue = false
                    $vm.endAtStatus.wrappedValue = .selected
                },
                       content: {
                    VStack(alignment: .leading, spacing: 0) {
                        HStack(alignment: .center, spacing: 0) {
                            Text("기간: 마지막일")
                                .sdFont(.headline2, color: Color.blackGray_900)
                            Spacer()
                            FPButton(text: "오늘", status: .able, size: .small, type: .textGray) {
                                $vm.endAt.wrappedValue = Date()
                            }
                            FPButton(text: "완료", status: .able, size: .small, type: .textGray) {
                                $isPresentEndAtCalendar.wrappedValue = false
                            }
                        }
                        .sdPaddingHorizontal(24)
                        .sdPaddingTop(26)
                        
                        
                        DatePicker(
                            "",
                            selection: $vm.endAt,
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
        })
        .id(CALENDAR_ID)
        .sdPaddingVertical(16)
    }
    
    private func drawTitle(_ text: String, isEssential: Bool) -> some View {
        HStack(alignment: .center, spacing: 4, content: {
            Text(text)
                .sdFont(.headline3, color: .black)
            Text(isEssential ? "*" : "")
                .sdFont(.headline3, color: .blue)
        })
    }
    
    private func drawHeader() -> some View {
        return ZStack(alignment: .leading) {
            Topbar(vm.type.title, type: .back) {
                self.output.pop()
            }
            HStack(alignment: .center, spacing: 12) {
                Spacer()
                if case .modify = vm.type {
                    FPButton(text: "삭제", status: .able, size: .small, type: .textGray) {
                        $isPresentDelete.wrappedValue = true
                    }
                }
                FPButton(text: "완료", status: $vm.isAvailableToSave.wrappedValue ? .able : .disable, size: .small, type: .textPrimary) {
                    vm.onSave {
//                        self.output.pop()
                        self.isPresentCreateComplete = true
                    }
                }
            }
        }
    }
    
    private func iconItem(_ item: TripIconEntity) -> some View {
        ZStack(alignment: .bottomTrailing,
               content: {
            TripIconItem(item: item)
                .padding(8)
                .background(
                    RoundedRectangle(cornerRadius: 2)
                        .foregroundStyle($vm.icon.wrappedValue == item ? Color.zineGray_200 : Color.clear)
                )
            if $vm.icon.wrappedValue == item {
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
            $vm.icon.wrappedValue = item
        }
    }
    
    private struct FootprintItem: View {
        let item: TripFootprintEntity
        
        var body: some View {
            VStack(alignment: .leading, spacing: 0, content: {
                Text(item.title)
                    .sdFont(.headline2, color: Color.cont_gray_default)
                    .lineLimit(1)
                
                Text(item.content)
                    .sdFont(.body3, color: Color.cont_gray_high)
                    .sdPaddingTop(16)
                    .lineLimit(1)
            })
            .sdPaddingHorizontal(16)
            .sdPaddingVertical(18)
            .frame(maxWidth: .infinity, alignment: .leading)
            .contentShape(Rectangle())
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .foregroundStyle(Color.bg_white)
            )
        }
    }
}

