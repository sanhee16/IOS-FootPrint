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
    @Binding var isShowSplash: Bool
    @StateObject private var vm: SplashVM2 = SplashVM2()
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.green)
            Text("Hello, SplashView!")
                .sdFont(.sys30b, color: .green)
        }
        .onAppear(perform: {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                withAnimation {
                    isShowSplash = false
                }
            }
        })
        .padding()
    }
}
