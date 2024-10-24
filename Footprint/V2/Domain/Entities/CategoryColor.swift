//
//  CategoryColor.swift
//  Footprint
//
//  Created by sandy on 10/24/24.
//

enum CategoryColor: Int {
    case black = 0
    case pink
    case orange
    case yellow
    case green
    case blue
    case purple
    /*
     
     case black = "#363943"
     case pink = "#fc1961"
     case orange = "#fa5252"
     case yellow = "#fcc216"
     case green = "#1fc998"
     case blue = "#349aef"
     case purple = "#8e5ce6"
     */
    var hex: String {
        switch self {
        case .black:
            return "#363943"
        case .pink:
            return "#fc1961"
        case .orange:
            return "#fa5252"
        case .yellow:
            return "#fcc216"
        case .green:
            return "#1fc998"
        case .blue:
            return "#349aef"
        case .purple:
            return "#8e5ce6"
        }
    }
}
