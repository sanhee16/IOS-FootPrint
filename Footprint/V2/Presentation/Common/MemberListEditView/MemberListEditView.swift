//
//  MemberListEditView.swift
//  Footprint
//
//  Created by sandy on 8/24/24.
//

import Foundation
import SwiftUI
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
    @State private var isPresentAddMember: Bool = false
    
    
    init(output: Output) {
        self.output = output
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0, content: {
            Topbar("함께한 사람 편집하기", type: .back) {
                output.pop()
            }
            ScrollView(.vertical, showsIndicators: false, content: {
                ForEach($vm.members.wrappedValue, id: \.self) { item in
                    HStack(alignment: .center, spacing: 16, content: {
                        memberItem(item)
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
            })
        })
        .alert(isPresented: $isPresentDelete) {
            Alert(
                title: Text("함께한 사람 삭제하기"),
                message: Text("삭제한 사람은 복구할 수 없습니다.\n‘\($vm.deleteMember.wrappedValue?.name ?? "")’를 삭제 하시겠습니까?"),
                primaryButton: .default(Text("취소"), action: {
                    $isPresentDelete.wrappedValue = false
                }),
                secondaryButton: .default(Text("삭제"), action: {
                    $isPresentDelete.wrappedValue = false
                    vm.onDelete()
                })
            )
        }
        .environmentObject(memberEditVM)
        .navigationBarBackButtonHidden()
        .onAppear(perform: {
            vm.loadMembers()
        })
    }
    
    private func memberItem(_ item: Member) -> some View {
        return HStack(alignment: .center, spacing: 8) {
            if !item.image.isEmpty, let image = ImageManager.shared.getSavedImage(named: item.image) {
                Image(uiImage: image)
                    .resizable()
                    .frame(both: 40.0, alignment: .center)
                    .clipShape(Circle())
            } else {
                Image("profile 1")
                    .resizable()
                    .frame(both: 40.0, alignment: .center)
                    .clipShape(Circle())
            }

            VStack(alignment: .leading, spacing: 4, content: {
                Text(item.name)
                    .sdFont(.headline3, color: .cont_gray_default)
                Text(item.intro)
                    .sdFont(.caption1, color: .cont_gray_mid)
            })
            Spacer()
        }
        .sdPaddingVertical(4)
        .sdPaddingHorizontal(8)
    }
}

