//
//  admob_testApp.swift
//  admob-test
//
//  Created by binhkid2 on 2026/05/10.
//

import GoogleMobileAds
import SwiftUI

@main
struct admob_testApp: App {
    init() {
        MobileAds.shared.start()
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
