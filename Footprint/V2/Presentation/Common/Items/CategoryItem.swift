//
//  CategoryItem.swift
//  Footprint
//
//  Created by sandy on 10/24/24.
//

import SwiftUI
import SDSwiftUIPack

struct CategoryItem: View {
    let item: CategoryEntity
    init(item: CategoryEntity) {
        self.item = item
    }
    
    var body: some View {
        HStack(alignment: .center, spacing: 8) {
            Image(item.icon.imageName)
                .resizable()
                .renderingMode(.template)
                .foregroundColor(Color(hex: item.color.hex))
                .frame(both: 16.0, alignment: .center)
            Text(item.name)
                .font(.headline3)
                .foregroundColor(Color(hex: item.color.hex))
        }
        .sdPaddingVertical(4)
        .sdPaddingHorizontal(8)
        .background(
            RoundedRectangle(cornerRadius: 4)
                .foregroundStyle(Color(hex: item.color.hex).opacity(0.1))
        )
    }
}
