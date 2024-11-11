//
//  DragAndDropService.swift
//  Footprint
//
//  Created by Studio-SJ on 2023/01/03.
//

import Foundation
import SwiftUI
import SDSwiftUIPack


struct DragAndDropService<T: Equatable>: DropDelegate {
    let currentItem: T
    @Binding var items: [T]
    @Binding var draggedItem: T?
    
    func performDrop(info: DropInfo) -> Bool {
        return true
    }
    
    func dropUpdated(info: DropInfo) -> DropProposal? {
        DropProposal(operation: .move)
    }

    func dropEntered(info: DropInfo) {
        guard let draggedItem = draggedItem,
              draggedItem != currentItem,
              let from = items.firstIndex(of: draggedItem),
              let to = items.firstIndex(of: currentItem)
        else {
            return
        }
        withAnimation {
            items.move(fromOffsets: IndexSet(integer: from), toOffset: to > from ? to + 1 : to)
        }
    }
    
    func dropExited(info: DropInfo) {
//        print("dropExited")
    }
}
