//
//  BaseCoordinator.swift
//  Footprint
//
//  Created by sandy on 8/10/24.
//

import Foundation
import SwiftUI

class BaseCoordinator<T: Hashable>: ObservableObject {
    @Published var paths: [T] = [] { didSet { print("paths: \(paths)" )}}
    
    func push(_ path: T) {
        self.paths.append(path)
    }
    
    func pop() {
        paths.removeLast()
    }
    
    func pop(to: T) {
        guard let found = paths.firstIndex(where: { $0 == to }) else {
            return
        }
        // 중복된 View가 있어도 맨 처음 push된 View로 pop시킨다.
        let numToPop = (found..<paths.endIndex).count - 1
        paths.removeLast(numToPop)
    }
    
    func popToRoot() {
        paths.removeAll()
    }

    func moveToDestination(destination: Destination) -> some View {
        return destination.view
    }
}

