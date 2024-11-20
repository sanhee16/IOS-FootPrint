//
//  TripCoordinator.swift
//  Footprint
//
//  Created by sandy on 11/20/24.
//

import Foundation
import Factory
import SwiftUI

class TripCoordinator: BaseCoordinator<Destination> {
    let tabBarService: TabBarService = TabBarService()
    
    private func pushEditNote(note: TemporaryNote, output: EditNoteView.Output) {
        self.push(.editNote(note: note, output: output))
    }
    
    private func pushCategoryListEditView(_ output: CategoryListEditView.Output) {
        self.push(.categoryListEditView(output: output))
    }
    
    private func pushPeopleWithListEditView(_ output: MemberListEditView.Output) {
        self.push(.peopleWithListEditView(output: output))
    }
    
    private func pushEditTripView(_ type: EditTripType) {
        self.push(.editTrip(type: type, output:  EditTripView.Output {
            self.pop()
        } popToList: {
            self.popToRoot()
        }))
    }
    
    private func pushTripDetailView(_ id: String) {
        self.push(.tripDetailView(id: id, output: TripDetailView.Output(pop: {
            self.pop()
        }, goToEditTrip: {
            self.pushEditTripView(.modify(id: id))
        })))
    }
}

//MARK: Output
extension TripCoordinator {
    var mapOutput: MapView2.Output {
        MapView2.Output { note in
            self.pushEditNote(note: note, output: self.editNoteOutput)
        }
    }
    
    var editNoteOutput: EditNoteView.Output {
        EditNoteView.Output {
            self.pop()
        } pushCategoryListEditView: {
            self.pushCategoryListEditView(self.categoryListEditViewOutput)
        } pushPeopleWithListEditView: {
            self.pushPeopleWithListEditView(self.peopleWithListEditViewOutput)
        } popToSelectLocation: {
            self.tabBarService.isShowTabBar = false
            
            
            self.popToRoot()
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
        TripListView.Output {type in
            self.pushEditTripView(type)
        } goToTripDetail: { id in
            self.pushTripDetailView(id)
        }
    }
    
    var footprintListViewOutput: FootprintListViewV2.Output {
        FootprintListViewV2.Output { note in
            self.pushEditNote(note: note, output: self.editNoteOutput)
        }
    }
}

