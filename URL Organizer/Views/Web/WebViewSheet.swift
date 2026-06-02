//
//  WebViewSheet.swift
//  URL Organizer
//
//  Created by Godsfavour Ngo Kio on 2026-06-02.
//

import SwiftUI

struct WebViewSheet: View {
    let url: URL
    
    var body: some View {
        WebView(url: url)
            .ignoresSafeArea()
    }
}

#Preview {
    WebViewSheet(url: URL(string: "https://godsfavourkio.com")!)
}
