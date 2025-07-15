//
//  WebView.swift
//  Vocabie
//
//  Created by Selvarajan on 28/05/22.
//

import SwiftUI
import WebKit

struct UIWebView: UIViewRepresentable {
    var url: URL
    func makeUIView(context: Context) -> WKWebView {
        print(url)
        return WKWebView()
    }
    func updateUIView(_ webView: WKWebView, context: Context) {
        let request = URLRequest(url: url)
        webView.load(request)
    }
}

struct WebView: View {
    @State var inputWord: String

    var body: some View {
        VStack {
            UIWebView(url: URL(string: "https://www.google.co.in/search?q=define+\(inputWord.lowercased().trim())")!)
        }
        .background(.red)
    }
}

struct WebView_Previews: PreviewProvider {
    static var previews: some View {
        WebView(inputWord: "act")
    }
}
