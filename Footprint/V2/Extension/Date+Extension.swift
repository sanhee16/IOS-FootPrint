//
//  Date+Extension.swift
//  Footprint
//
//  Created by sandy on 8/15/24.
//

import Foundation

extension Date {
    var toEditNoteDate: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy. MM. dd"
        return dateFormatter.string(from: self)
    }
}
