//
//  PeopleWithView.swift
//  Footprint
//
//  Created by sandy on 11/1/24.
//

import SwiftUI
import SDSwiftUIPack


struct PeopleWithView: View {
    var members: [MemberEntity]
    
    init(members: [MemberEntity]) {
        self.members = members
    }
    
    var body: some View {
        HStack(alignment: .center, spacing: 0, content: {
            ZStack(alignment: .center, content: {
                ForEach(members.prefix(3).indices, id: \.self) { idx in
                    if !members[idx].image.isEmpty,
                        let image = ImageManager.shared.getSavedImage(named: members[idx].image) {
                        Image(uiImage: image)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(both: 40)
                            .clipped()
                            .clipShape(Circle())
                            .border(.blueGray_200, lineWidth: 0.7, cornerRadius: 40.0)
                            .offset(x: CGFloat(idx) * 24.0)
                            .zIndex(3 - Double(idx))
                    } else {
                        Image("profile 1")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(both: 40)
                            .clipped()
                            .clipShape(Circle())
                            .border(.blueGray_200, lineWidth: 0.7, cornerRadius: 40.0)
                            .offset(x: CGFloat(idx) * 24.0)
                            .zIndex(3 - Double(idx))
                    }
                }
            })
            .sdPaddingTrailing(16)
            
            if let firstMember = members.first {
                HStack(alignment: .center, spacing: 0, content: {
                    Text(firstMember.name)
                        .sdFont(.headline3, color: .cont_gray_default)
                    if members.count > 1 {
                        Text("외")
                            .sdFont(.body3, color: .cont_gray_default)
                            .sdPadding(top: 0, leading: 4, bottom: 0, trailing: 8)
                        Text("\(members.count - 1)")
                            .sdFont(.headline3, color: .cont_gray_default)
                        Text("명")
                            .sdFont(.body3, color: .cont_gray_default)
                    }
                })
                .offset(x: CGFloat(members.prefix(3).count - 1) * 24.0)
            }
        })
    }
}
