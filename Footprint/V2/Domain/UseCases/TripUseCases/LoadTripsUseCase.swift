//
//  LoadTripsUseCase.swift
//  Footprint
//
//  Created by sandy on 11/14/24.
//

class LoadTripsUseCase {
    private let tripRepository: TripRepository
    private let tripIconRepository: TripIconRepository
    private let noteRepository: NoteRepository
    
    init(tripRepository: TripRepository, tripIconRepository: TripIconRepository, noteRepository: NoteRepository) {
        self.tripRepository = tripRepository
        self.tripIconRepository = tripIconRepository
        self.noteRepository = noteRepository
    }
    
    func execute() -> [TripEntity] {
        guard let value = try? self.tripRepository.loadTrips().get() else { return [] }
        var result: [TripEntity] = []
        value.forEach { dao in
            do {
                guard let iconDao = try? self.tripIconRepository.loadTripIcon(id: dao.iconId).get(),
                      let tripIcon = TripIcon(rawValue: iconDao.iconName) else {
                    return
                }
                let icon = TripIconEntity(id: iconDao.id, icon: tripIcon, isSelected: true)
                var footprints: [TripFootprintEntity] = []
                var idx: Int = 0
                
                dao.footprintIds.forEach { id in
                    guard let note = self.noteRepository.loadNote(id: id) else {
                        return
                    }
                    footprints.append(
                        TripFootprintEntity(
                            id: note.id,
                            idx: idx,
                            title: note.title,
                            content: note.content,
                            address: note.address
                        )
                    )
                    idx += 1
                }
                
                result.append(TripEntity(
                    id: dao.id,
                    title: dao.title,
                    content: dao.content,
                    icon: icon,
                    footprints: footprints,
                    startAt: dao.startAt,
                    endAt: dao.endAt
                ))
            }
        }
        return result
    }
}
