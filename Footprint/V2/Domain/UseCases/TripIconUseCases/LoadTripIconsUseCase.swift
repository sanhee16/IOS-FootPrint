//
//  LoadTripIconsUseCase.swift
//  Footprint
//
//  Created by sandy on 11/14/24.
//

class LoadTripIconsUseCase {
    var tripIconRepository: TripIconRepository
    
    init(tripIconRepository: TripIconRepository) {
        self.tripIconRepository = tripIconRepository
    }
    
    func execute() -> [TripIconEntity] {
        guard let value = try? self.tripIconRepository.loadTripIcons().get() else { return [] }
        var result: [TripIconEntity] = []
        
        value.forEach { dao in
            guard let tripIcon = TripIcon(rawValue: dao.iconName) else {
                return
            }
            result.append(TripIconEntity(id: dao.id, icon: tripIcon, isSelected: false))
        }
        
        return result
    }
}
