//
//  BaseViewModel.swift
//  Footprint
//
//  Created by sandy on 8/8/24.
//

import Foundation
import Factory

enum ViewEvent: Equatable {
    static func == (lhs: ViewEvent, rhs: ViewEvent) -> Bool {
        lhs.event == rhs.event
    }
    
    case goToFootprintView(location: Location)
    case none
    
    var event: String {
        switch self {
        case .goToFootprintView(let location):
            return "goToFootprintView"
        case .none:
            return "none"
        }
    }
}


class BaseViewModel: ObservableObject {
    @Published var viewEvent: ViewEvent = .none
    
}
