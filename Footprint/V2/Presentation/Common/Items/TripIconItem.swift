//
//  TripIconItem.swift
//  Footprint
//
//  Created by sandy on 11/14/24.
//


import SwiftUI
import SDSwiftUIPack

struct TripIconItem: View {
    let item: TripIconEntity
    init(item: TripIconEntity) {
        self.item = item
    }
    
    var body: some View {
        Image(item.icon.imageName)
            .resizable()
            .font(.system(size: 24.0))
            .frame(both: 24.0, alignment: .center)
    }
}
