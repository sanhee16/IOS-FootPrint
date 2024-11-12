//
//  MemberListEditView.swift
//  Footprint
//
//  Created by sandy on 8/24/24.
//

import Foundation
import SwiftUI
import UniformTypeIdentifiers
import SDSwiftUIPack

struct MemberListEditView: View {
    struct Output {
        var pop: () -> ()
    }
    
    enum ViewEventTrigger {
        case pop
    }
    
    private var output: Output
    
    @StateObject var vm: MemberListEditVM = MemberListEditVM()
    @StateObject var memberEditVM: MemberEditVM = MemberEditVM()
    @State private var isPresentDelete: Bool = false
    @State private var isPresentDeleteComplete: Bool = false
    @State private var isPresentAddMember: Bool = false
    @State private var draggedItem: MemberEntity? = nil
    
    
    init(output: Output) {
        self.output = output
    }
    
    var body: some View {
        VStack(alignment: .leading,
               spacing: 0,
               content: {
            Topbar("함께한 사람 편집하기", type: .back) {
                output.pop()
            }
            ScrollView(.vertical,
                       showsIndicators: false,
                       content: {
                ForEach($vm.members.wrappedValue, id: \.self) { item in
                    if $vm.isLoading.wrappedValue {
                        memberItem(item)
                    } else {
                        memberItem(item)
                            .onDrag {
                                $draggedItem.wrappedValue = item
                                return NSItemProvider(item: nil, typeIdentifier: item.id)
                            }
                            .onDrop(
                                of: [UTType.text],
                                delegate: DragAndDropService<MemberEntity>(
                                    currentItem: item,
                                    items: $vm.members,
                                    draggedItem: $draggedItem
                                )
                            )
                    }
                }
                
                FPButton(text: "사람 추가하기", status: .able, size: .large, type: .lightSolid) {
                    memberEditVM.setMember(nil)
                    $isPresentAddMember.wrappedValue = true
                }
                .sdPaddingVertical(8)
                .sdPaddingHorizontal(16)
                .sdPaddingBottom(20)
                .sheet(isPresented: $isPresentAddMember, onDismiss: {
                    vm.loadMembers()
                }, content: {
                    MemberEditView(isPresented: $isPresentAddMember)
                        .presentationDetents([.medium, .large])
                })
                VStack{}
                    .alert(isPresented: $isPresentDelete) {
                        Alert(
                            title: Text("함께한 사람 삭제하기"),
                            message: Text("삭제한 사람은 복구할 수 없습니다.\n‘\($vm.deleteMember.wrappedValue?.name ?? "")’를 삭제 하시겠습니까?"),
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
                            message: Text("‘\($vm.deleteMember.wrappedValue?.name ?? "")’를 삭제했습니다."),
                            dismissButton: .default(Text("확인"), action: {
                                $vm.deleteMember.wrappedValue = nil
                            })
                        )
                    }
            })
        })
        .environmentObject(memberEditVM)
        .navigationBarBackButtonHidden()
        .onAppear(perform: {
            vm.loadMembers()
        })
    }
    
    private func memberItem(_ item: MemberEntity) -> some View {
        return HStack(alignment: .center, spacing: 16, content: {
            MemberItem(item: item)
                .sdPaddingVertical(4)
                .sdPaddingHorizontal(8)
            Spacer()
            Image("ModifyButton")
                .resizable()
                .frame(both: 24.0, alignment: .center)
                .contentShape(Rectangle())
                .onTapGesture {
                    memberEditVM.setMember(item)
                    $isPresentAddMember.wrappedValue = true
                }
            Image("TrashButton")
                .resizable()
                .frame(both: 24.0, alignment: .center)
                .contentShape(Rectangle())
                .onTapGesture {
                    $vm.deleteMember.wrappedValue = item
                    $isPresentDelete.wrappedValue = true
                }
        })
        .padding(16)
        .contentShape(Rectangle())
    }
}

