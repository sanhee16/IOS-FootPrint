//
//  WebView.swift
//  Footprint
//
//  Created by sandy on 2022/10/08.
//

import SwiftUI
import SDSwiftUIPack
import WebKit

struct MyWebView: UIViewRepresentable {
    func updateUIView(_ uiView: WKWebView, context: Context) {
        
    }
    
    var urlToLoad: String
    
    func makeUIView(context: Context) -> WKWebView {
        guard let url = URL(string: self.urlToLoad) else {
            return WKWebView()
        }
        
        let webView = WKWebView()
        let theFileName = (urlToLoad as NSString).lastPathComponent
        let htmlPath = Bundle.main.path(forResource: theFileName, ofType: "html")
        
        let folderPath = Bundle.main.bundlePath
        
        let baseUrl = URL(fileURLWithPath: folderPath, isDirectory: true)
        
        do {
            let htmlString = try NSString(contentsOfFile: htmlPath!, encoding: String.Encoding.utf8.rawValue)
            webView.loadHTMLString(htmlString as String, baseURL: baseUrl)
        } catch {
            
            // catch error
            
        }
        
        //webView.navigationDelegate = self
        
        webView.scrollView.bounces = false
        webView.scrollView.isScrollEnabled = true
        webView.isOpaque = false
        webView.isHidden = false
        
        return webView
        
    }
}

//
//struct MyWebView_Previews: PreviewProvider {
//    static var previews: some View {
//        MyWebView(urlToLoad: "https://www.naver.com")
//    }
//}
