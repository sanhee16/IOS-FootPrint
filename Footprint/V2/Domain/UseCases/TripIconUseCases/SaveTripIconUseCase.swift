//
//  SaveTripIconUseCase.swift
//  Footprint
//
//  Created by sandy on 11/13/24.
//

class SaveTripIconUseCase {
    var tripIconRepository: TripIconRepository
    
    init(tripIconRepository: TripIconRepository) {
        self.tripIconRepository = tripIconRepository
    }
    
    func execute(_ icon: TripIcon) -> String? {
        let result = self.tripIconRepository.saveTripIcon(icon: icon)
        
        switch result {
        case .success(let id):
            return id
        case .failure(let failure):
            return nil
        }
    }
}
