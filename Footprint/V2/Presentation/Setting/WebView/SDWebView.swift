//
//  WebView.swift
//  Footprint
//
//  Created by sandy on 11/26/24.
//

import SwiftUI
import WebKit

struct WebView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    let title: String
    let url: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0, content: {
            Topbar(title, type: .back) {
                self.presentationMode.wrappedValue.dismiss()
            }
            SDWebView(url: url)
                .layoutPriority(1)
        })
        .navigationBarBackButtonHidden()
    }
}

struct SDWebView: UIViewRepresentable {
    var url: String
    
    func makeUIView(context: Context) -> WKWebView {
        guard let url = URL(string: url) else {
            return WKWebView()
        }
        let webView = WKWebView()
        webView.load(URLRequest(url: url))
        return webView
    }
    
    func updateUIView(_ webView: WKWebView, context: UIViewRepresentableContext<SDWebView>) {
        guard let url = URL(string: url) else { return }
        webView.load(URLRequest(url: url))
    }
}
