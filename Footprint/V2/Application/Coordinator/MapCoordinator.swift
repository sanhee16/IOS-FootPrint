//
//  MapCoordinator.swift
//  Footprint
//
//  Created by sandy on 8/10/24.
//

import Foundation
import Factory
import SwiftUI

class MapCoordinator: BaseCoordinator<Destination> {
    private let mapManager: FPMapManager = FPMapManager.shared
    
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
    
    private func pushSelectLocationView(_ location: Location) {
        self.push(.selectLocation(output: SelectLocationView.Output(pop: {
            self.pop()
        }), location: location))
    }
}

//MARK: Output
extension MapCoordinator {
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
        } pushSelectLocation: { location in
            NotificationCenter.default.post(name: .changeMapStatus, object: MapStatus.adding.rawValue)
            self.pop()
            Task {
                await self.mapManager.moveToLocation(location)
            }
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
    
    var tripListViewOutput: TripListView.Output {
        TripListView.Output {type in
            self.pushEditTripView(type)
        } goToTripDetail: { id in
            self.pushTripDetailView(id)
        }
    }
    
    var footprintListViewOutput: FootprintListViewV2.Output {
        FootprintListViewV2.Output { type in
            self.pushEditNote(type: type, output: self.editNoteOutput)
        }
    }
}
