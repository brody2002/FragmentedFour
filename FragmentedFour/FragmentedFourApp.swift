//
//  FragmentedFourApp.swift
//  FragmentedFour
//
//  Created by Brody on 11/26/24.
//

import AVFoundation
import SwiftUI
import SwiftData


@main
struct FragmentedFourApp: App {
    @StateObject private var userData = UserData()
    @StateObject private var globalAudio = GlobalAudioSettings()
    @AppStorage("firstLoad") private var firstLoad: Bool = true // Loads data on first load of installing app
//    @AppStorage("lastLoadedVersion") private var lastLoadedVersion: String = "1"
    
    var body: some Scene {
        WindowGroup {
            ZStack{
                HomeView(firstLoad: $firstLoad)
            }
            .interactiveDismissDisabled()
            .environmentObject(userData)
            .environmentObject(globalAudio)
            .modelContainer(for: [Level.self, Pack.self])
//            .onAppear {
//                let currentVersion: String = (Bundle.main.infoDictionary?["NSBundleVersion"] as? String) ?? "1"
//                if lastLoadedVersion.compare(currentVersion, options: .numeric) == .orderedAscending {
//                    // upgrade
//                    
//                    
//                    lastLoadedVersion = currentVersion
//                }
//            }
            // Zac's idea on how to implement the updates
            // iOS migration methods  
        }
        
    }
}
