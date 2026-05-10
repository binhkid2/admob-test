//
//  ContentView.swift
//  admob-test
//
//  Created by binhkid2 on 2026/05/10.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            BannerAdDemoView()
                .tabItem {
                    Label("Banner", systemImage: "rectangle.bottomthird.inset.filled")
                }

            InterstitialAdDemoView()
                .tabItem {
                    Label("Interstitial", systemImage: "rectangle.inset.filled")
                }

            NativeAdvancedAdDemoView()
                .tabItem {
                    Label("Native", systemImage: "square.text.square")
                }
        }
    }
}

#Preview {
    ContentView()
}
