//
//  DataModel.swift
//  Footprint
//
//  Created by sandy on 2022/11/10.
//

import Foundation
import SwiftUI
import MapKit
import GoogleMaps

/*
 MAX: 8개인데 더 늘릴려면 Defaults.settingFlag 설정해줘야함
 */
enum SettingFlag: Int {
    case SEARCH_BAR = 0
    case FILTER = 1
    
    var option: UInt8 {
        0b1 << self.rawValue
    }
}

struct SearchItemResponse {
    var name: String
    var fullAddress: String
    var secondaryAddress: String?
    var placeId: String
    var types: [String]
}

struct MarkerItem {
    var marker: GMSMarker
    var footPrint: FootPrint
}

enum PinColor: Int {
    case pin0
    case pin1
    case pin2
    case pin3
    case pin4
    case pin5
    case pin6
    case pin7
    case pin8
    case pin9
    
    
    var pinColorHex: String {
        switch self {
        case .pin0: return "#000000"
        case .pin1: return "#FC1961"
        case .pin2: return "#FA5252"
        case .pin3: return "#8D5DE8"
        case .pin4: return "#CC5DE8"
        case .pin5: return "#5C7CFA"
        case .pin6: return "#339AF0"
        case .pin7: return "#20C997"
        case .pin8: return "#94D82D"
        case .pin9: return "#FCC419"
        }
    }
    
    var pinUIColor: UIColor {
        switch self {
        case .pin0: return UIColor.pin0
        case .pin1: return UIColor.pin1
        case .pin2: return UIColor.pin2
        case .pin3: return UIColor.pin3
        case .pin4: return UIColor.pin4
        case .pin5: return UIColor.pin5
        case .pin6: return UIColor.pin6
        case .pin7: return UIColor.pin7
        case .pin8: return UIColor.pin8
        case .pin9: return UIColor.pin9
        }
    }
}


enum PinType: Int {
    case star
    case restaurant
    case coffee
    case bread
    case cake
    case wine
    case exercise
    case heart
    case multiply
    case like
    case unlike
    case done
    case exclamation
    case happy
    case square
    
    var pinName: String {
        switch self {
        case .star: return "star"
        case .restaurant: return "restaurant"
        case .coffee: return "coffee"
        case .bread: return "bread"
        case .cake: return "cake"
        case .wine: return "wine"
        case .exercise: return "exercise"
        case .heart: return "heart"
        case .multiply: return "multiply"
        case .like: return "like"
        case .unlike: return "unlike"
        case .done: return "done"
        case .exclamation: return "exclamation"
        case .happy: return "happy"
        case .square: return "square"
        }
    }
    
    var pinWhite: String {
        switch self {
        case .restaurant: return "restaurant_w"
        case .coffee: return "coffee_w"
        case .bread: return "bread_w"
        case .cake: return "cake_w"
        case .wine: return "wine_w"
        case .exercise: return "exercise_w"
        case .heart: return "heart_w"
        case .star: return "star_w"
        case .multiply: return "multiply_w"
        case .like: return "like_w"
        case .unlike: return "unlike_w"
        case .done: return "done_w"
        case .exclamation: return "exclamation_w"
        case .happy: return "happy_w"
        case .square: return "square_w"
        }
    }
    
    var pinBlack: String {
        switch self {
        case .restaurant: return "restaurant_b"
        case .coffee: return "coffee_b"
        case .bread: return "bread_b"
        case .cake: return "cake_b"
        case .wine: return "wine_b"
        case .exercise: return "exercise_b"
        case .heart: return "heart_b"
        case .star: return "star_b"
        case .multiply: return "multiply_b"
        case .like: return "like_b"
        case .unlike: return "unlike_b"
        case .done: return "done_b"
        case .exclamation: return "exclamation_b"
        case .happy: return "happy_b"
        case .square: return "square_b"
        }
    }
    
    var marker: String {
        switch self {
        case .restaurant: return "mark_restaurant"
        case .coffee: return "mark_coffee"
        case .bread: return "mark_bread"
        case .cake: return "mark_cake"
        case .wine: return "mark_wine"
        case .exercise: return "mark_exercise"
        case .heart: return "mark_heart"
        case .star: return "mark_star"
        case .multiply: return "mark_multiply"
        case .like: return "mark_like"
        case .unlike: return "mark_unlike"
        case .done: return "mark_done"
        case .exclamation: return "mark_exclamation"
        case .happy: return "mark_happy"
        case .square: return "mark_square"
        }
    }
    
    var markerW: String {
        switch self {
        case .restaurant: return "mark_restaurant_w"
        case .coffee: return "mark_coffee_w"
        case .bread: return "mark_bread_w"
        case .cake: return "mark_cake_w"
        case .wine: return "mark_wine_w"
        case .exercise: return "mark_exercise_w"
        case .heart: return "mark_heart_w"
        case .star: return "mark_star_w"
        case .multiply: return "mark_multiply_w"
        case .like: return "mark_like_w"
        case .unlike: return "mark_unlike_w"
        case .done: return "mark_done_w"
        case .exclamation: return "mark_exclamation_w"
        case .happy: return "mark_happy_w"
        case .square: return "mark_square_w"
        }
    }
    
    var markerClear: String {
        switch self {
        case .restaurant: return "mark_restaurant_clear"
        case .coffee: return "mark_coffee_clear"
        case .bread: return "mark_bread_clear"
        case .cake: return "mark_cake_clear"
        case .wine: return "mark_wine_clear"
        case .exercise: return "mark_exercise_clear"
        case .heart: return "mark_heart_clear"
        case .star: return "mark_star_clear"
        case .multiply: return "mark_multiply_clear"
        case .like: return "mark_like_clear"
        case .unlike: return "mark_unlike_clear"
        case .done: return "mark_done_clear"
        case .exclamation: return "mark_exclamation_clear"
        case .happy: return "mark_happy_clear"
        case .square: return "mark_square_clear"
        }
    }
}
