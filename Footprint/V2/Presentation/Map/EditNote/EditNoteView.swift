//
//  EditNoteView.swift
//  Footprint
//
//  Created by sandy on 8/10/24.
//

import SwiftUI
import Photos
import PhotosUI
import SDSwiftUIPack

struct EditNoteView: View {
    struct Output {
        var pop: () -> ()
        var pushCategoryListEditView: () -> ()
        var pushPeopleWithListEditView: () -> ()
        var popToSelectLocation: () -> ()
    }
    
    private var output: Output
    
    @StateObject var vm: EditNoteVM
    
    init(note: TemporaryNote, output: Output) {
        _vm = StateObject(wrappedValue: EditNoteVM(note: note))
        self.output = output
    }
    
    private var safeTop: CGFloat { get { Util.safeTop() }}
    private var safeBottom: CGFloat { get { Util.safeBottom() }}
    private let IMAGE_SIZE: CGFloat = 70.0
    
    @State private var isPresentCategoryList: Bool = false
    @State private var isPresentCalendar: Bool = false
    @State private var isPresentGallery: Bool = false
    @State private var isPresentPeopleWith: Bool = false
    
    private let CALENDAR_ID: String = "CALENDAR_ID"
    private let CATEGORY_ID: String = "CATEGORY_ID"
    private let LOCATION_ID: String = "LOCATION_ID"
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            drawHeader()
            ScrollViewReader { scrollProxy in
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 10) {
                        drawTitle("제목", isEssential: true)
                            .sdPaddingTop(24)
                        Group {
                            FPTextField(placeHolder: "title".localized(), text: $vm.title, fieldStyle: .line, lineStyle: .single(limit: nil))
                            
                            drawTitle("내용", isEssential: false)
                                .sdPaddingTop(24)
                            FPTextField(placeHolder: "content".localized(), text: $vm.content, fieldStyle: .line, lineStyle: .multi(limit: nil))
                            
                            drawTitle("위치", isEssential: true)
                                .sdPaddingTop(24)
                            FPTextField(placeHolder: "".localized(), text: $vm.address, fieldStyle: .none, lineStyle: .multi(limit: nil), isDisabled: true)
                            
                            FPButton(text: "발자국 위치 확인하기", status: .able, size: .large, type: .lightSolid) {
                                vm.saveTempNote {
                                    self.output.popToSelectLocation()
                                }
                            }
                            .sdPaddingVertical(8)
                            .id(LOCATION_ID)
                            
                            Divider()
                                .background(Color.dim_black_low)
                                .sdPaddingVertical(8)
                        }
                        
                        drawDate(scrollProxy: scrollProxy)
                        drawCategory(scrollProxy: scrollProxy)
                        
                        if (!$vm.images.wrappedValue.isEmpty) || (!$vm.imageUrls.wrappedValue.isEmpty) {
                            drawTitle("사진", isEssential: false)
                                .sdPaddingTop(24)
                            ScrollView(.horizontal, showsIndicators: false) {
                                LazyHStack(alignment: .center, spacing: 16, content: {
                                    if !$vm.imageUrls.wrappedValue.isEmpty {
                                        ForEach(0..<$vm.imageUrls.wrappedValue.count, id: \.self) { index in
                                            if let dir = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false),
                                               let uiImage = UIImage(contentsOfFile: URL(fileURLWithPath: dir.absoluteString).appendingPathComponent($vm.imageUrls.wrappedValue[index]).path) {
                                                ZStack(alignment: .topTrailing) {
                                                    Image(uiImage: uiImage)
                                                        .resizable()
                                                        .scaledToFill()
                                                        .frame(both: 80.0, alignment: .center)
                                                        .clipShape(
                                                            Rectangle()
                                                        )
                                                    
                                                    Image("DeleteButton")
                                                        .resizable()
                                                        .scaledToFit()
                                                        .frame(both: 16.0, alignment: .center)
                                                        .contentShape(Rectangle())
                                                        .offset(x: 8, y: -8)
                                                        .zIndex(1)
                                                        .onTapGesture {
                                                            vm.deleteImageUrl(index)
                                                        }
                                                }
                                                .frame(both: 88.0, alignment: .bottomLeading)
                                            }
                                        }
                                    }
                                    if !$vm.images.wrappedValue.isEmpty {
                                        ForEach(0..<$vm.images.wrappedValue.count, id: \.self) { index in
                                            ZStack(alignment: .topTrailing) {
                                                Image(uiImage: $vm.images.wrappedValue[index])
                                                    .resizable()
                                                    .scaledToFill()
                                                    .frame(both: 80.0, alignment: .center)
                                                    .clipShape(
                                                        Rectangle()
                                                    )
                                                
                                                Image("DeleteButton")
                                                    .resizable()
                                                    .scaledToFit()
                                                    .frame(both: 16.0, alignment: .center)
                                                    .contentShape(Rectangle())
                                                    .offset(x: 8, y: -8)
                                                    .zIndex(1)
                                                    .onTapGesture {
                                                        vm.deleteImage(index)
                                                    }
                                            }
                                            .frame(both: 88.0, alignment: .bottomLeading)
                                        }
                                    }
                                })
                            }
                        }
                        if !$vm.selectedMembers.wrappedValue.isEmpty {
                            PeopleWithView(members: $vm.selectedMembers.wrappedValue)
                                .sdPaddingVertical(8)
                        }
                    }
                    .sdPaddingHorizontal(16)
                    .sdPaddingBottom(14)
                }
            }
            .ignoresSafeArea(.keyboard, edges: [.bottom])
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.bg_default)
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
            
            
            HStack(alignment: .center, spacing: 8, content: {
                PhotosPicker(
                    selection: $vm.selectedPhotos, // holds the selected photos from the picker
                    maxSelectionCount: nil, // sets the max number of photos the user can select
                    selectionBehavior: .ordered, // ensures we get the photos in the same order that the user selected them
                    matching: .images, // filter the photos library to only show images,
                    photoLibrary: .shared()
                ) {
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
                }
                .onChange(of: vm.selectedPhotos, perform: { value in
                    vm.addImage()
                })
                
                
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
                    $isPresentPeopleWith.wrappedValue = true
                }
                .sheet(isPresented: $isPresentPeopleWith, onDismiss: {
                    
                }, content: {
                    VStack(alignment: .leading, spacing: 0, content: {
                        HStack(alignment: .center, spacing: 0) {
                            Text("함께한 사람")
                            Spacer()
                            FPButton(text: "편집", status: .able, size: .small, type: .textGray) {
                                $isPresentPeopleWith.wrappedValue = false
                                output.pushPeopleWithListEditView()
                            }
                        }
                        .sdPaddingHorizontal(24)
                        .sdPaddingTop(26)
                        .onAppear {
                            vm.loadMembers()
                        }
                        
                        ScrollView(.vertical, showsIndicators: false, content: {
                            ForEach($vm.entireMembers.wrappedValue, id: \.self) { item in
                                HStack(alignment: .center, spacing: 0, content: {
                                    memberItem(item)
                                    Spacer()
                                })
                                .padding(16)
                                .contentShape(Rectangle())
                                .onTapGesture {
                                    vm.toggleMember(item)
                                }
                            }
                            .sdPaddingBottom(20)
                        })
                    })
                    .presentationDetents([.medium, .large])
                })
                Spacer()
            })
            .sdPaddingVertical(4)
            .sdPaddingHorizontal(16)
            .frame(width: UIScreen.main.bounds.width)
            .background(Color.bg_bgb)
        }
        .navigationBarBackButtonHidden()
    }
    
    private func drawCategory(scrollProxy: ScrollViewProxy) -> some View {
        HStack(alignment: .center, spacing: 0, content: {
            drawTitle("카테고리", isEssential: true)
                .frame(width: 100, height: 40, alignment: .leading)
            if let selectedCategory = $vm.category.wrappedValue {
                CategoryItem(item: selectedCategory)
            }
            
            Spacer()
            Image("ic_arrow_right")
                .font(.system(size: 16))
        })
        .id(CATEGORY_ID)
        .onTapGesture {
            scrollProxy.scrollTo(LOCATION_ID, anchor: .top)
            vm.loadCategories()
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
                }
                .sdPaddingHorizontal(24)
                .sdPaddingTop(26)
                
                ScrollView(.vertical, showsIndicators: false, content: {
                    ForEach($vm.categories.wrappedValue, id: \.self) { item in
                        HStack(alignment: .center, spacing: 0, content: {
                            CategoryItem(item: item)
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
            Image("ic_arrow_right")
                .font(.system(size: 16))
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
    
    private func drawHeader() -> some View {
        return ZStack(alignment: .leading) {
            Topbar("발자국 남기기", type: .back) {
                vm.clearFootprint()
                self.output.pop()
            }
            HStack(alignment: .center, spacing: 12) {
                Spacer()
                Image("ic_star")
                    .renderingMode(.template)
                    .resizable()
                    .scaledToFit()
                    .foregroundColor($vm.isStar.wrappedValue ? Color.btn_ic_cont_default : Color.btn_ic_cont_disable)
                    .frame(both: 20.0, alignment: .center)
                    .onTapGesture {
                        $vm.isStar.wrappedValue = !$vm.isStar.wrappedValue
                    }
                FPButton(text: "완료", status: $vm.isAvailableToSave.wrappedValue ? .able : .disable, size: .small, type: .textPrimary) {
                    vm.saveNote {
                        self.output.pop()
                    }
                }
            }
        }
    }
    
    private func drawTitle(_ text: String, isEssential: Bool) -> some View {
        HStack(alignment: .center, spacing: 4, content: {
            Text(text)
                .sdFont(.headline3, color: .black)
            Text(isEssential ? "*" : "")
                .sdFont(.headline3, color: .blue)
        })
    }
    
    private func memberItem(_ item: MemberEntity) -> some View {
        return HStack(alignment: .center, spacing: 8) {
            MemberItem(item: item)
            Spacer()
            if $vm.selectedMembers.wrappedValue.contains(where: { $0.id == item.id }) {
                Image("SelectButton")
                    .resizable()
                    .frame(width: 16.0, height: 16.0, alignment: .center)
            }
        }
        .sdPaddingVertical(4)
        .sdPaddingHorizontal(8)
        .contentShape(Rectangle())
    }
}
