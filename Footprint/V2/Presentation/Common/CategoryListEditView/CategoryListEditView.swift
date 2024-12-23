//
//  CategoryListEditView.swift
//  Footprint
//
//  Created by sandy on 8/23/24.
//

import Foundation
import SwiftUI
import UniformTypeIdentifiers
import SDSwiftUIPack

struct CategoryListEditView: View {
    struct Output {
        var pop: () -> ()
    }
    
    enum ViewEventTrigger {
        case pop
    }
    
    private var output: Output
    
    @StateObject var vm: CategoryListEditVM = CategoryListEditVM()
    @StateObject var categoryEditVM: CategoryEditVM = CategoryEditVM()
    @State private var draggedItem: CategoryEntity? = nil
    @State private var isPresentDelete: Bool = false
    @State private var isPresentDeleteComplete: Bool = false
    @State private var isPresentAddCategory: Bool = false
    
    
    init(output: Output) {
        self.output = output
    }
    
    private var safeTop: CGFloat { get { Util.safeTop() }}
    private var safeBottom: CGFloat { get { Util.safeBottom() }}
    
    var body: some View {
        VStack(alignment: .leading,
               spacing: 0,
               content: {
            Topbar("카테고리 편집하기", type: .back) {
                output.pop()
            }
            ScrollView(.vertical,
                       showsIndicators: false,
                       content: {
                ForEach($vm.categories.wrappedValue, id: \.self) { item in
                    if item.isDeletable {
                        categoryItem(item)
                        .onDrag {
                            $draggedItem.wrappedValue = item
                            return NSItemProvider(item: nil, typeIdentifier: item.id)
                        }
                        .onDrop(
                            of: [UTType.text],
                            delegate: DragAndDropService<CategoryEntity>(
                                currentItem: item,
                                items: $vm.categories,
                                draggedItem: $draggedItem
                            )
                        )
                    } else {
                        categoryItem(item)
                    }
                }
                FPButton(text: "카테고리 추가하기", status: .able, size: .large, type: .lightSolid) {
                    categoryEditVM.setCategory(nil)
                    $isPresentAddCategory.wrappedValue = true
                }
                .sdPaddingVertical(8)
                .sdPaddingHorizontal(16)
                .sdPaddingBottom(20)
                .sheet(isPresented: $isPresentAddCategory, onDismiss: {
                    vm.loadCategories()
                }, content: {
                    CategoryEditView(isPresented: $isPresentAddCategory)
                })
                
                VStack{}
                    .alert(isPresented: $isPresentDelete) {
                        Alert(
                            title: Text("카테고리 삭제하기"),
                            message: Text(
                                $vm.deleteCategoryNoteCount.wrappedValue > 0
                                ? "‘\($vm.deleteCategory.wrappedValue?.name ?? "")’ 카테고리에 \($vm.deleteCategoryNoteCount.wrappedValue)개의 발자국이 있습니다.\n삭제 시 이 카테고리에 속한 모든 발자국이 삭제됩니다."
                                : "‘\($vm.deleteCategory.wrappedValue?.name ?? "")’ 카테고리를 삭제하시겠습니까?"
                            ),
                            primaryButton: .default(Text("취소"), action: {
                                
                            }),
                            secondaryButton: .default(Text("삭제"), action: {
                                vm.onDelete()
                                DispatchQueue.main.async {
                                    $isPresentDeleteComplete.wrappedValue = true
                                }
                            })
                        )
                    }
                
                VStack{}
                    .alert(isPresented: $isPresentDeleteComplete) {
                        Alert(
                            title: Text("삭제완료"),
                            message: Text("‘\($vm.deleteCategory.wrappedValue?.name ?? "")’를 삭제했어요."),
                            dismissButton: .default(Text("확인"), action: {
                                $vm.deleteCategory.wrappedValue = nil
                            })
                        )
                    }
            })
        })
        .navigationBarBackButtonHidden()
        .environmentObject(categoryEditVM)
        .onAppear(perform: {
            vm.loadCategories()
        })
    }
    
    private func categoryItem(_ item: CategoryEntity) -> some View {
        HStack(alignment: .center, spacing: 16, content: {
            CategoryItem(item: item)
            Spacer()
            if item.isDeletable {
                Image("ModifyButton")
                    .resizable()
                    .frame(both: 24.0, alignment: .center)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        categoryEditVM.setCategory(item)
                        $isPresentAddCategory.wrappedValue = true
                    }
                Image("TrashButton")
                    .resizable()
                    .frame(both: 24.0, alignment: .center)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        vm.getDeletedCategoryNoteCount(item) {
                            $isPresentDelete.wrappedValue = true
                        }
                    }
            }
        })
        .padding(16)
        .contentShape(Rectangle())
    }
}

