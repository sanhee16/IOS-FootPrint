//
//  EditTripView.swift
//  Footprint
//
//  Created by sandy on 11/14/24.
//

import SwiftUI

struct EditTripView: View {
    struct Output {
        var pop: () -> ()
    }
    private let output: Output
    @EnvironmentObject var vm: EditTripVM
    
    init(output: Output) {
        self.output = output
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0, content: {
            drawHeader()
        })
        .background(Color.bg_bgb)
        .navigationBarBackButtonHidden()
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
    }
    
    private func drawHeader() -> some View {
        return ZStack(alignment: .leading) {
            Topbar("발자취 만들기", type: .back) {
                self.output.pop()
            }
            HStack(alignment: .center, spacing: 12) {
                Spacer()
                FPButton(text: "완료", status: $vm.isAvailableToSave.wrappedValue ? .able : .disable, size: .small, type: .textPrimary) {
                    
                }
            }
        }
    }
}

