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
    var body: some Scene {
        WindowGroup {
            ZStack{
                HomeView(firstLoad: $firstLoad)
            }
            .interactiveDismissDisabled()
            .environmentObject(userData)
            .environmentObject(globalAudio)
            .modelContainer(for: [Level.self, Pack.self])
        }
        
    }
}
