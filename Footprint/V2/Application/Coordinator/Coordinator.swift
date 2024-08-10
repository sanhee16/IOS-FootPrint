//
//  Coordinator.swift
//  Footprint
//
//  Created by sandy on 8/10/24.
//

import Foundation
import Factory
import SwiftUI

class Coordinator: BaseCoordinator<Destination> {
    //MARK: Main Tab Views' Output
    var mapOutput: MapView2.Output {
        MapView2.Output(goToFootprintView: { location in
            self.pushFootprintView(location)
        })
    }
//    
//    var tabOutputB: TabBView.Output {
//        TabBView.Output(
//            goToDetailView1: self.pushDetailView1,
//            goToDetailView2: self.pushDetailView2
//        )
//    }
//    
//    //MARK: Change View
//    private func pushDetailView1() {
//        self.push(.detailView1(output: DetailView1.Output(
//            goToMain: self.popToRoot,
//            goToDetailView1: self.pushDetailView1,
//            goToDetailView2: self.pushDetailView2
//        )))
//    }
//    
//    private func pushDetailView2() {
//        self.push(.detailView2(output: DetailView2.Output(
//            goToMain: self.popToRoot,
//            goToDetailView1: self.pushDetailView1,
//            goToDetailView2: self.pushDetailView2
//        )))
//    }
//    
//    private func pushDetailView3() {
//        self.push(.detailView3(output: DetailView3.Output(
//            goToMain: self.popToRoot,
//            goToDetailView1: self.pushDetailView1,
//            goToDetailView2: self.pushDetailView2
//        )))
//    }
    
    private func pushFootprintView(_ location: Location) {
        self.push(.footprint(location: location))
    }
}

