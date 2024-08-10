//
//  Destination.swift
//  Footprint
//
//  Created by sandy on 8/10/24.
//

import Foundation
import SwiftUI

enum Destination: Hashable {
    case footprint(location: Location)
    
    var viewName: String {
        switch self {
        case .footprint:
            return "footprint"
        }
    }
    
    @ViewBuilder
    var view: some View {
        switch self {
        case .footprint(let location):
            FootprintView(location: location)
        }
    }
}

extension Destination {
    static func == (lhs: Destination, rhs: Destination) -> Bool {
        return lhs.viewName == rhs.viewName
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.viewName)
    }
}
