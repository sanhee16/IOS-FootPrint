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
    private func pushEditNote(type: EditNoteType, output: EditNoteView.Output) {
        self.push(.editNote(type: type, output: output))
    }
    
    private func pushCategoryListEditView(_ output: CategoryListEditView.Output) {
        self.push(.categoryListEditView(output: output))
    }
    
    private func pushPeopleWithListEditView(_ output: MemberListEditView.Output) {
        self.push(.peopleWithListEditView(output: output))
    }
    
    private func pushEditTripView(_ type: EditTripType) {
        self.push(.editTrip(type: type, output: EditTripView.Output(pop: {
            self.pop()
        })))
    }
}

//MARK: Output
extension Coordinator {
    var mapOutput: MapView2.Output {
        MapView2.Output { type in
            self.pushEditNote(type: type, output: self.editNoteOutput)
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
        } goToEditNote: { type in
            self.pushEditNote(type: type, output: self.editNoteOutput)
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
    
    var tripListViewOutput: TripListView.Output {
        TripListView.Output { type in
            self.pushEditTripView(type)
        }
    }
}
