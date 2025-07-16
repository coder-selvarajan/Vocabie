//
//  VocabieApp.swift
//  VocabieApp
//
//  Created by Selvarajan on 13/03/22.
//

import SwiftUI
import Apptics

@main
struct VocabieApp: App {
//    @State private var dictionaryService = AIDictionaryService()
    
    init() {
        AppticsConfig.default.enableAutomaticCrashTracking = true
        AppticsConfig.default.enableAutomaticEventTracking = true
        AppticsConfig.default.enableAutomaticScreenTracking = true
        AppticsConfig.default.enableAutomaticSessionTracking = true
        AppticsConfig.default.flushInterval = APFlushInterval.interval10
        Apptics.initialize(withVerbose: false)
    }
    
    var body: some Scene {
        WindowGroup {
            HomeView()
                .colorScheme(.light)
                .environment(AIDictionaryService())
            
//                .environmentObject(dictionaryService)
//                .environment(\.colorScheme, .light)
        }
    }
}

// R 88
// G 86
// B 214

// Font : Qahiri
// Font : Dubtronic, Dubtronic Inlin
// Font : Clutchee
// Font : Bearpaw
// Font : Anagram
