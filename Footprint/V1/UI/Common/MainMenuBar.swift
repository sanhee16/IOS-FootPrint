//
//  MainMenuBar.swift
//  Footprint
//
//  Created by sandy on 2023/01/15.
//

import Foundation
import SwiftUI
import SDSwiftUIPack

public struct MainMenuElements {
    var current: MainMenuType
    var onClick: ((MainMenuType)->())?
}

public enum MainMenuType: Int, Equatable {
    case map
    case footprints
    case trip
    case favorite
    case setting
    
    var onImage: String {
        switch self {
        case .map: return "ic_location_compass_on"
        case .footprints: return "ic_feet_on"
        case .trip: return "ic_arrow-roadmap_on"
        case .favorite: return "favorite_on"
        case .setting: return "ic_setting_on"
        }
    }
    
    var offImage: String {
        switch self {
        case .map: return "ic_location_compass_off"
        case .footprints: return "ic_feet_off"
        case .trip: return "ic_arrow-roadmap_off"
        case .favorite: return "favorite_off"
        case .setting: return "ic_setting_off"
        }
    }
    
    var text: String {
        switch self {
        case .map: return "map".localized()
        case .footprints: return "footprints".localized()
        case .trip: return "travel".localized()
        case .favorite: return "favorite".localized()
        case .setting: return "setting".localized()
        }
    }
    
    var viewName: String {
        switch self {
        case .map: return String(describing: MainView.self)
        case .footprints: return String(describing: FootprintListView.self)
        case .trip: return String(describing: TravelListView.self)
        case .favorite: return String(describing: TravelListView.self)
        case .setting: return String(describing: SettingView.self)
        }
    }
}

public struct MainMenuBar: View {
    private var current: MainMenuType
    private var onClick: ((MainMenuType)->())?
    private let ICON_SIZE: CGFloat = 24.0
    private let ITEM_WIDTH: CGFloat = UIScreen.main.bounds.width / 4
    private let ITEM_HEIGHT: CGFloat = 64.0
    private let list: [MainMenuType] = [.map, .footprints, .trip, .setting]
    
    init(current: MainMenuType, onClick: ((MainMenuType)->())?) {
        self.current = current
        self.onClick = onClick
    }
    
    public var body: some View {
        HStack(alignment: .center, spacing: 0) {
            ForEach(self.list.indices, id: \.self) { idx in
                drawItem(self.list[idx], isSelected: self.list[idx] == self.current)
            }
        }
        .background(Color.backgroundColor)
    }
    
    private func drawItem(_ item: MainMenuType, isSelected: Bool) -> some View {
        return VStack(alignment: .center, spacing: 8) {
            Image(isSelected ? item.onImage : item.offImage)
                .resizable()
                .scaledToFit()
                .frame(both: ICON_SIZE, alignment: .center)
            Text(item.text)
                .sdFont(.caption2, color: isSelected ? Color.cont_primary_mid : Color.cont_gray_mid)
        }
        .frame(width: ITEM_WIDTH, height: ITEM_HEIGHT, alignment: .center)
        .contentShape(Rectangle())
        .onTapGesture {
            switch item {
            case .map: self.onClick?(.map)
            case .footprints: self.onClick?(.footprints)
            case .trip: self.onClick?(.trip)
            case .favorite: self.onClick?(.favorite)
            case .setting: self.onClick?(.setting)
            }
        }
    }
}



