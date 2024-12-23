//
//  FootprintCoordinator.swift
//  Footprint
//
//  Created by sandy on 11/20/24.
//

import Foundation
import Factory
import SwiftUI

class FootprintCoordinator: BaseCoordinator<Destination> {
    private func pushEditNote(type: EditNoteType, output: EditNoteView.Output) {
        self.push(.editNote(type: type, output: output))
    }
    
    private func pushCategoryListEditView(_ output: CategoryListEditView.Output) {
        self.push(.categoryListEditView(output: output))
    }
    
    private func pushPeopleWithListEditView(_ output: MemberListEditView.Output) {
        self.push(.peopleWithListEditView(output: output))
    }
    
    private func pushSelectLocationView(_ location: Location) {
        self.push(.selectLocation(output: SelectLocationView.Output(pop: {
            self.pop()
        }), location: location))
    }
    
    private func pushFootprintListWtihSameAddressView(_ address: String) {
        self.push(.footprintListWtihSameAddressView(address: address, output: self.footprintListWtihSameAddressViewOutput))
    }
}

//MARK: Output
extension FootprintCoordinator {
    var editNoteOutput: EditNoteView.Output {
        EditNoteView.Output {
            self.pop()
        } pushCategoryListEditView: {
            self.pushCategoryListEditView(self.categoryListEditViewOutput)
        } pushPeopleWithListEditView: {
            self.pushPeopleWithListEditView(self.peopleWithListEditViewOutput)
        } pushSelectLocation: { location in
            self.pushSelectLocationView(location)
        }
    }
    
    var selectLocationOutput: SelectLocationView.Output {
        SelectLocationView.Output {
            self.pop()
        }
    }
    
    var categoryListEditViewOutput: CategoryListEditView.Output {
        CategoryListEditView.Output {
            self.pop()
        }
    }
    
    var peopleWithListEditViewOutput: MemberListEditView.Output {
        MemberListEditView.Output {
            self.pop()
        }
    }
    
    var footprintListViewOutput: FootprintListViewV2.Output {
        FootprintListViewV2.Output { type in
            self.pushEditNote(type: type, output: self.editNoteOutput)
        } pushFootprintListWtihSameAddressView: { address in
            self.pushFootprintListWtihSameAddressView(address)
        }
    }
    
    var footprintListWtihSameAddressViewOutput: FootprintListWtihSameAddressView.Output {
        FootprintListWtihSameAddressView.Output { type in
            self.pushEditNote(type: type, output: self.editNoteOutput)
        } pop: {
            self.pop()
        }
    }
}
