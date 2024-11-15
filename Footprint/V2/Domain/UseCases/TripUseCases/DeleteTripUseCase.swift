//
//  DeleteTripUseCase.swift
//  Footprint
//
//  Created by sandy on 11/15/24.
//

class DeleteTripUseCase {
    let tripRepository: TripRepository
    
    init(tripRepository: TripRepository) {
        self.tripRepository = tripRepository
    }
    
    func execute(_ id: String) -> String? {
        let result = self.tripRepository.deleteTrip(id)
        switch result {
        case .success(let id):
            return id
        case .failure(let failure):
            return nil
        }
    }
}
