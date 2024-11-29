//
//  FragmentedFourApp.swift
//  FragmentedFour
//
//  Created by Brody on 11/26/24.
//
import SwiftUI
import SwiftData


@main
struct FragmentedFourApp: App {
    @Environment(\.modelContext) var modelContext

    var body: some Scene {
        WindowGroup {
            LevelView()
                .onAppear {
                    // Check if it's the first launch EVER
//                    if UserDefaults.standard.bool(forKey: "firstLaunchEver") == false {
//                        initializeAppData()
//                        // Set the flag to true so initialization doesn't run again
//                        UserDefaults.standard.set(true, forKey: "firstLaunchEver")
//                    }
                    initializeAppData()
                }
                .modelContainer(for: Level.self)
                
        }
    }

    func initializeAppData() {
        print("Initializing app data for first launch...")
        let levels: [[String]] = Bundle.main.decode("levels.txt")
        for (index, wordsList) in levels.enumerated() {
            
            
            
            modelContext.insert(Level(level: index + 1, words: wordsList, completed: false, rank: "Novice", score: 0))
            print("Level \(index + 1) inserted...")
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
