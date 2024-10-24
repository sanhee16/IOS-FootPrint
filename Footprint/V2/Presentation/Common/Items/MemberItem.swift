//
//  MemberItem.swift
//  Footprint
//
//  Created by sandy on 10/24/24.
//

import Foundation
import SwiftUI
import SDSwiftUIPack

struct MemberItem: View {
    let item: MemberEntity
    init(item: MemberEntity) {
        self.item = item
    }
    
    var body: some View {
        HStack(alignment: .center, spacing: 8) {
            if !item.image.isEmpty, let image = ImageManager.shared.getSavedImage(named: item.image) {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(both: 40.0, alignment: .center)
                    .clipped()
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
        }
    }
}
