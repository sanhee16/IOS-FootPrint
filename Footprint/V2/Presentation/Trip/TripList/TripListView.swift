//
//  TripListView.swift
//  Footprint
//
//  Created by sandy on 11/12/24.
//

import SwiftUI

struct TripListView: View {
    struct Output {
        var goToEditTrip: (EditTripType) -> ()
    }
    
    private var output: Output
    @EnvironmentObject private var tabBarService: TabBarService
    @StateObject private var vm: TripListVM = TripListVM()
    
    init(output: Output) {
        self.output = output
    }
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            VStack(alignment: .leading, spacing: 0, content: {
                
            })
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            FPButton(text: "발자취 만들기", location: .leading(name: "arrow-roadmap"), status: .able, size: .medium, type: .solid) {
                self.output.goToEditTrip(.create)
            }
            .shadow(color: Color.dropSahdow_primary_low.opacity(0.15), radius: 4, x: 0, y: 2)
            .padding(16)
            .zIndex(1)
        }
    }
}
