//
//  Destination.swift
//  Footprint
//
//  Created by sandy on 8/10/24.
//

import Foundation
import SwiftUI

enum Destination: Hashable {
    case selectLocation(output: SelectLocationView.Output)
    case editNote(output: EditNoteView.Output, location: Location, type: EditNoteType)
    case categoryListEditView(output: CategoryListEditView.Output)
    case peopleWithListEditView(output: MemberListEditView.Output)
    
    var viewName: String {
        switch self {
        case .selectLocation:
            return "selectLocation"
        case .editNote:
            return "editNote"
        case .categoryListEditView:
            return "categoryListEditView"
        case .peopleWithListEditView:
            return "peopleWithListEditView"
        }
    }
    
    @ViewBuilder
    var view: some View {
        switch self {
        case .selectLocation(let output):
            SelectLocationView(output: output)
        case .editNote(let output, let location, let type):
            EditNoteView(output: output, location: location, type: type)
        case .categoryListEditView(let output):
            CategoryListEditView(output: output)
        case .peopleWithListEditView(let output):
            MemberListEditView(output: output)
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
