//
//  SplashView2.swift
//  Footprint
//
//  Created by sandy on 8/8/24.
//

import SwiftUI
import SDSwiftUIPack
import Factory
import SDSwiftUIPack

struct SplashView2: View {
    @Binding var isShowMain: Bool
    @StateObject var vm = SplashVM2()
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.green)
            Text("Hello, SplashView!")
                .sdFont(.sys30b, color: .green)
        }
        .onChange(of: vm.isShowMain, perform: { value in
            self.isShowMain = value
        })
    }
}
