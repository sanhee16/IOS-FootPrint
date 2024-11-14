//
//  EditTripVM.swift
//  Footprint
//
//  Created by sandy on 11/14/24.
//

import Combine

public enum EditTripType {
    case create
    case modify(id: String)
}

class EditTripVM: ObservableObject {
    private let type: EditTripType
    
    @Published var isAvailableToSave: Bool = false
    
    init(type: EditTripType) {
        self.type = type
    }
}
