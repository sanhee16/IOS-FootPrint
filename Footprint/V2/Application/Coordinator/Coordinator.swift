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
    //MARK: Main Tab Views' Output
    var mapOutput: MapView2.Output {
        MapView2.Output { location in
            self.pushFootprintView(location)
        } goToEditNote: { location, type in
            self.pushEditNote(self.editNoteOutput, location: location, type: type)
        }
    }
    
    var editNoteOutput: EditNoteView.Output {
        EditNoteView.Output(pop: {
            self.pop()
        }, pushCategoryListEditView: {
            self.pushCategoryListEditView(CategoryListEditView.Output(pop: {
                self.pop()
            }))
        })
    }
    
    var selectLocationOutput: SelectLocationView.Output {
        SelectLocationView.Output {
            self.pop()
        } goToEditNote: { location, type in
            self.pushEditNote(self.editNoteOutput, location: location, type: type)
        }
    }
    
    private func pushFootprintView(_ location: Location) {
        self.push(.footprint(location: location))
    }
    
    
    private func pushSelectLocationView(_ output: SelectLocationView.Output) {
        self.push(.selectLocation(output: output))
    }
    
    private func pushEditNote(_ output: EditNoteView.Output, location: Location, type: EditFootprintType) {
        self.push(.editNote(output: output, location: location, type: type))
    }
    
    private func pushCategoryListEditView(_ output: CategoryListEditView.Output) {
        self.push(.categoryListEditView(output: output))
    }
}

