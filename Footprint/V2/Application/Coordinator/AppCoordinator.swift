//
//  AppCoordinator.swift
//  Footprint
//
//  Created by sandy on 12/24/24.
//

import Foundation
import Factory
import SwiftUI

class AppCoordinator: BaseCoordinator<Destination> {
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
        self.push(.editTrip(type: type, output: self.editTripViewOutput))
    }
    
    private func pushTripDetailView(_ id: String) {
        self.push(.tripDetailView(id: id, output: self.tripDetailViewOutput(id)))
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
extension AppCoordinator {
    var editTripViewOutput: EditTripView.Output {
        EditTripView.Output {
            self.pop()
        } popToList: {
            self.popToRoot()
        }
    }
    
    var editNoteOutput: EditNoteView.Output {
        EditNoteView.Output {
            self.pop()
        } pushCategoryListEditView: {
            self.pushCategoryListEditView(self.categoryListEditViewOutput)
        } pushPeopleWithListEditView: {
            self.pushPeopleWithListEditView(self.memberListEditViewOutput)
        } pushSelectLocation: { location in
            self.pushSelectLocationView(location)
        }
    }
    
    func tripDetailViewOutput(_ id: String) -> TripDetailView.Output {
        TripDetailView.Output(pop: {
            self.pop()
        }, goToEditTrip: {
            self.pushEditTripView(.modify(id: id))
        }, pushFootprintListWtihSameAddressView: { address in
            self.pushFootprintListWtihSameAddressView(address)
        })
    }
    
    var mapOutput: MapView2.Output {
        MapView2.Output { type in
            self.pushEditNote(type: type, output: self.editNoteOutput)
        } pushFootprintListWtihSameAddressView: { address in
            self.pushFootprintListWtihSameAddressView(address)
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
    
    var memberListEditViewOutput: MemberListEditView.Output {
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

