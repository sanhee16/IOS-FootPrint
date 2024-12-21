//
//  SearchView.swift
//  Footprint
//
//  Created by sandy on 12/21/24.
//

import SwiftUI

struct SearchView: View {
    @Environment(\.deviceWidth) private var deviceWidth
    @StateObject private var searchVM: SearchVM = SearchVM()
    @EnvironmentObject private var mapManager: FPMapManager

    @Binding var isShowSearchBar: Bool
    @Binding var menuIconSize: CGSize
    @State private var status: SearchStatus = .none
    @State private var boxSize: CGSize = .zero
    
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8, content: {
            searchBox()
                .frame(width: deviceWidth - 16 * 2 - $menuIconSize.wrappedValue.width - 8, alignment: .leading)
            if $status.wrappedValue != .none {
                drawSearchList()
                    .frame(maxWidth: .infinity)
            }
        })
    }
    
    private func drawSearchList() -> some View {
        return ScrollView(.vertical, showsIndicators: true) {
            VStack(alignment: .leading, spacing: 8) {
                ForEach($searchVM.searchItems.wrappedValue.indices, id: \.self) { idx in
                    searchItem($searchVM.searchItems.wrappedValue[idx])
                        .skeleton($status.wrappedValue == .searching, reason: .placeholder)
                }
            }
        }
        .frame(height: 65 * 3, alignment: .center)
        .background(Color.dim_white_high)
//        .sdPaddingHorizontal(16)
    }
    
    private func searchItem(_ item: SearchEntity) -> some View {
        return VStack(alignment: .leading, spacing: 4) {
            Text(item.name)
                .sdFont(.body1, color: Color.cont_gray_default)
            Text(item.fullAddress)
                .sdFont(.body3, color: Color.cont_gray_mid)
        }
        .sdPadding(top: 8, leading: 16, bottom: 12, trailing: 16)
        .contentShape(Rectangle())
        .frame(maxWidth: .infinity, alignment: .leading)
        .onTapGesture {
            searchVM.getLocation(item.placeId) { location in
                if let location = location {
                    mapManager.moveToLocation(location)
                    self.isShowSearchBar.toggle()
                }
            }
        }
    }
    
    private func searchBox() -> some View {
        return HStack(alignment: .center) {
            TextField("", text: $searchVM.searchText, prompt: Text("검색어를 입력하세요").sdFont(.body1, color: Color.cont_gray_low).sdPaddingLeading(12) as? Text)
                .sdFont(.body1, color: Color.cont_gray_default)
                .accentColor(.fColor2)
                .sdPaddingHorizontal(8)
                .layoutPriority(.greatestFiniteMagnitude)
                .onChange(of: $searchVM.searchText.wrappedValue) { _ in
                    searchVM.onTypeText { status in
                        self.status = status
                    }
                }
            
            if !$searchVM.searchText.wrappedValue.isEmpty {
                Button {
                    searchVM.onCancel { status in
                        self.status = status
                    }
                } label: {
                    Image("ic_close")
                        .resizable()
                        .renderingMode(.template)
                        .foregroundColor(Color.cont_gray_mid)
                        .frame(both: 10.0, alignment: .center)
                        .sdPaddingTrailing(12)
                        .sdPaddingTrailing(8)
                        .contentShape(Rectangle())
                }
                .zIndex(10)
            }
        }
        .sdPaddingVertical(10)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .foregroundColor(Color.bg_white)
                .border(Color.btn_ic_stroke_default, lineWidth: 0.75, cornerRadius: 8)
        )
        .contentShape(Rectangle())
        .shadow(color: .black.opacity(0.15), radius: 8, x: 0, y: 2)
    }
}
