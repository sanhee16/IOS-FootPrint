//
//  FootprintItem.swift
//  Footprint
//
//  Created by sandy on 2023/01/08.
//

import Foundation
import SwiftUI

public struct FootprintItem: View {
    private let IMAGE_SIZE: CGFloat = 50.0
    
    private let item: FootPrint
    private let peopleWiths: [PeopleWith]
    private let onClickImage: ((Int)->())
    private let onClickItem: (()->())
    private var isExpanded: Bool
    private let geometry: GeometryProxy
    private var horizontalPadding: CGFloat
    
    init(geometry: GeometryProxy, horizontalPadding: CGFloat = 20.0, item: FootPrint, isExpanded: Bool, peopleWiths: [PeopleWith], onClickImage: @escaping ((Int)->()), onClickItem: @escaping (()->())) {
        self.geometry = geometry
        self.horizontalPadding = horizontalPadding
        self.item = item
        self.onClickItem = onClickItem
        self.onClickImage = onClickImage
        self.peopleWiths = peopleWiths
        self.isExpanded = isExpanded
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(alignment: .center, spacing: 0) {
                Text(item.title)
                    .font(.kr14b)
                    .foregroundColor(.textColor1)
                Spacer()
                Image(isExpanded ? "up_arrow" : "down_arrow")
                    .resizable()
                    .scaledToFit()
                    .frame(both: 16.0, aligment: .center)
            }
            .padding([.leading, .trailing], 12)

            if let category = item.tag.getCategory() {
                HStack(alignment: .center, spacing: 6) {
                    Image(category.pinType.pinType().pinWhite)
                        .resizable()
                        .frame(both: 18.0, aligment: .center)
                        .colorMultiply(Color(hex: category.pinColor.pinColor().pinColorHex))
                    Text(category.name)
                        .font(.kr12r)
                        .foregroundColor(Color(hex: category.pinColor.pinColor().pinColorHex))
                }
                .padding([.leading, .trailing], 12)
            }
            if isExpanded {
                VStack(alignment: .leading, spacing: 8) {
                    drawPeopleWith(geometry, items: self.peopleWiths)
                    drawCreatedAt(geometry, item: item)
                }
                .padding([.leading, .trailing], 12)

                if !item.images.isEmpty {
                    drawImageArea(geometry, item: item)
                }
                Text(item.content)
                    .font(.kr13r)
                    .foregroundColor(.gray90)
                    .padding([.leading, .trailing], 12)
            }
        }
        .padding([.top, .bottom], 16)
        .frame(width: geometry.size.width - horizontalPadding * 2, alignment: .leading)
        .contentShape(Rectangle())
        .background(
            RoundedRectangle(cornerRadius: 12)
                .foregroundColor(Color.white)
        )
        .padding([.leading, .trailing], horizontalPadding)
        .onTapGesture {
            withAnimation {
                self.onClickItem()
//                    vm.onClickItem(item)
            }
        }
    }
    
    
    private func drawCreatedAt(_ geometry: GeometryProxy, item: FootPrint) -> some View {
        return HStack(alignment: .center, spacing: 4) {
            Image("calendar")
                .resizable()
                .frame(both: 18.0, aligment: .center)
            Text(item.createdAt.getDate())
                .font(.kr11r)
                .foregroundColor(Color.gray90)
        }
    }
    
    private func drawPeopleWith(_ geometry: GeometryProxy, items: [PeopleWith]) -> some View {
        return HStack(alignment: .center, spacing: 4) {
            Image("person")
                .resizable()
                .frame(both: 18.0, aligment: .center)
            HStack(alignment: .center, spacing: 8) {
                ForEach(items, id: \.self) { item in
                    Text(item.name)
                        .font(.kr11r)
                        .foregroundColor(Color.gray90)
                }
            }
        }
    }
    
    private func drawImageArea(_ geometry: GeometryProxy, item: FootPrint) -> some View {
        return ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(item.images.indices, id: \.self) { idx in
                    if let dir = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false),
                       let uiImage = UIImage(contentsOfFile: URL(fileURLWithPath: dir.absoluteString).appendingPathComponent(item.images[idx]).path) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFill()
                            .frame(both: IMAGE_SIZE)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .contentShape(Rectangle())
                            .shadow(color: Color.black.opacity(0.3), radius: 2, x: 0.5, y: 0.5)
                            .onTapGesture {
                                self.onClickImage(idx)
//                                vm.showImage(idx)
                            }
                    }
                }
            }
            .padding(EdgeInsets(top: 3, leading: 12, bottom: 8, trailing: 12))
        }
    }
}


