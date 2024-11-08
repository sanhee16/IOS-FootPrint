//
//  CategoryListEditView.swift
//  Footprint
//
//  Created by sandy on 8/23/24.
//

import Foundation
import SwiftUI
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
    @State private var isPresentDelete: Bool = false
    @State private var isPresentAddCategory: Bool = false
    
    
    init(output: Output) {
        self.output = output
    }
    
    private var safeTop: CGFloat { get { Util.safeTop() }}
    private var safeBottom: CGFloat { get { Util.safeBottom() }}
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0, content: {
            Topbar("카테고리 편집하기", type: .back) {
                output.pop()
            }
            ScrollView(.vertical, showsIndicators: false, content: {
                ForEach($vm.categories.wrappedValue, id: \.self) { item in
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
                                    vm.deleteCategory(item.id)
                                }
                        }
                    })
                    .padding(16)
                    .contentShape(Rectangle())
                    .onTapGesture {

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
            })
        })
        .navigationBarBackButtonHidden()
        .environmentObject(categoryEditVM)
        .onAppear(perform: {
            vm.loadCategories()
        })
    }
}

