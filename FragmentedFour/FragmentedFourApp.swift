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
    @Environment(\.modelContext) var modelContext
    @StateObject private var userData = UserData()
    var body: some Scene {
        WindowGroup {
            HomeView()
                .modelContainer(for: Level.self)
                .environmentObject(userData)
                .task {
                    if UserDefaults.standard.bool(forKey: "firstLaunchEver") == false {
                        initializeAppData() // for first ever launch
                        UserDefaults.standard.set(true, forKey: "firstLaunchEver")
                    }
                }
        }
    }
    func initializeAppData() {
        print("Initializing app data for first launch...")
        let levels: [[String]] = Bundle.main.decode("levels.txt")
        for (index, _) in levels.enumerated() {
            print("inserting")
            if index == 0 {
                modelContext.insert(Level(level: index, foundWords: [[String]](), foundQuartiles: [String](), completed: false, rank: "Novice", score: 0, unlocked: true))
            } else {
                if (1...4).contains(index){
                    modelContext.insert(Level(level: index, foundWords: [[String]](), foundQuartiles: [String](), completed: false, rank: "Novice", score: 0, unlocked: false))
                } else{
                    modelContext.insert(Level(level: index, foundWords: [[String]](), foundQuartiles: [String](), completed: false, rank: "Novice", score: 0, unlocked: false, redeemed: false))
                }
                
            }
            print("Level \(index) inserted...")
        }
        // Save the context to persist the data
        do {
            try modelContext.save()
            print("Data initialized and saved successfully.")
        } catch {
            print("Failed to save context: \(error)")
        }
        print(modelContext.container)
    }
}
