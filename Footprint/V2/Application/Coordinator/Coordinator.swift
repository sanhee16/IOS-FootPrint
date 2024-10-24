//
//  Coordinator.swift
//  Footprint
//
//  Created by sandy on 8/10/24.
//

import Foundation
import Factory
import SwiftUI

class Coordinator: BaseCoordinator<Destination> {
    private func pushFootprintView(_ location: Location) {
        self.push(.footprint(location: location))
    }
    
    
    private func pushSelectLocationView(_ output: SelectLocationView.Output) {
        self.push(.selectLocation(output: output))
    }
    
    private func pushEditNote(_ output: EditNoteView.Output, location: Location, type: EditNoteType) {
        self.push(.editNote(output: output, location: location, type: type))
    }
    
    private func pushCategoryListEditView(_ output: CategoryListEditView.Output) {
        self.push(.categoryListEditView(output: output))
    }
    
    private func pushPeopleWithListEditView(_ output: MemberListEditView.Output) {
        self.push(.peopleWithListEditView(output: output))
    }
}

//MARK: Output
extension Coordinator {
    var mapOutput: MapView2.Output {
        MapView2.Output { location in
            self.pushFootprintView(location)
        } goToEditNote: { location, type in
            self.pushEditNote(self.editNoteOutput, location: location, type: type)
        }
    }
    
    var editNoteOutput: EditNoteView.Output {
        EditNoteView.Output {
            self.pop()
        } pushCategoryListEditView: {
            self.pushCategoryListEditView(self.categoryListEditViewOutput)
        } pushPeopleWithListEditView: { 
            self.pushPeopleWithListEditView(self.peopleWithListEditViewOutput)
        }
    }
    
    var selectLocationOutput: SelectLocationView.Output {
        SelectLocationView.Output {
            self.pop()
        } goToEditNote: { location, type in
            self.pushEditNote(self.editNoteOutput, location: location, type: type)
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
}
