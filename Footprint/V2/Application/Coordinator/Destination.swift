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
    case selectLocation(output: SelectLocationView.Output)
    case editNote(output: EditNoteView.Output, location: Location, type: EditFootprintType)
    case categoryListEditView(output: CategoryListEditView.Output)
    
    var viewName: String {
        switch self {
        case .footprint:
            return "footprint"
        case .selectLocation:
            return "selectLocation"
        case .editNote:
            return "editNote"
        case .categoryListEditView:
            return "categoryListEditView"
        }
    }
    
    @ViewBuilder
    var view: some View {
        switch self {
        case .footprint(let location):
            FootprintView(location: location)
        case .selectLocation(let output):
            SelectLocationView(output: output)
        case .editNote(let output, let location, let type):
            EditNoteView(output: output, location: location, type: type)
        case .categoryListEditView(output: let output):
            CategoryListEditView(output: output)
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
