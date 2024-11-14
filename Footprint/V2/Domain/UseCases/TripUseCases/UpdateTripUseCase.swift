//
//  UpdateTripUseCase.swift
//  Footprint
//
//  Created by sandy on 11/14/24.
//

class UpdateTripUseCase {
    let tripRepository: TripRepository
    
    init(tripRepository: TripRepository) {
        self.tripRepository = tripRepository
    }
    
    func execute(id: String, title: String, content: String, iconId: String, footprintIds: [String], startAt: Int, endAt: Int) -> String? {
        let result = self.tripRepository.updateTrip(
            id: id,
            title: title,
            content: content,
            iconId: iconId,
            footprintIds: footprintIds,
            startAt: startAt,
            endAt: endAt
        )
        
        switch result {
        case .success(let id):
            return id
        case .failure(let failure):
            return nil
        }
    }
}
