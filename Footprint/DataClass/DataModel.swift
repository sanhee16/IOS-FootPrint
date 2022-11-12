//
//  DataModel.swift
//  Footprint
//
//  Created by sandy on 2022/11/10.
//

import Foundation
import SwiftUI
import MapKit
import NMapsMap

struct MarkerItem {
    var marker: NMFMarker
    var footPrint: FootPrint
}


enum PinType: Int {
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
    
    var pinName: String {
        switch self {
        case .pin0: return "pin0"
        case .pin1: return "pin1"
        case .pin2: return "pin2"
        case .pin3: return "pin3"
        case .pin4: return "pin4"
        case .pin5: return "pin5"
        case .pin6: return "pin6"
        case .pin7: return "pin7"
        case .pin8: return "pin8"
        case .pin9: return "pin9"
        }
    }
    
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
