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
    var tripListViewOutput: TripListView.Output {
        TripListView.Output {type in
            self.pushEditTripView(type)
        } goToTripDetail: { id in
            self.pushTripDetailView(id)
        }
    }
}

