//
//  ProgressView.swift
//  Footprint
//
//  Created by sandy on 2022/10/09.
//
import UIKit
import SwiftUI
import SDSwiftUIPack

// A view letting you adjust the progress with tap gestures
struct SandyProgressView: View {
    @State private var progress = 0.2

    var size: CGFloat = 140
    var body: some View {
        ProgressView(value: progress, total: 1.0)
            .progressViewStyle(CustomProgressView())
            .frame(both: size)
            .contentShape(Rectangle())
            .onTapGesture {
                if progress < 1.0 {
                    withAnimation {
                        progress += 0.2
                    }
                }
            }
    }
}

struct CustomProgressView: ProgressViewStyle {
    var strokeColor = Color.blue
    var strokeWidth = 25.0

    func makeBody(configuration: Configuration) -> some View {
        let fractionCompleted = configuration.fractionCompleted ?? 0

        return ZStack {
            LottieView(filename: "loading_bar")
        }
    }
}
