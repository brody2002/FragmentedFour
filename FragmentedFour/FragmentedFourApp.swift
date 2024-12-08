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
            ZStack{
                HomeView()
                    .modelContainer(for: [Level.self, Pack.self])
                    .environmentObject(userData)
            }
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
        //Load Levels in context
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
        // Insert Packs to the model Context
        modelContext.insert(Pack(name: "6-10", unlocked: false, price: 200, id: 1))
        modelContext.insert(Pack(name: "11-15", unlocked: false, price: 600, id: 2))
        modelContext.insert(Pack(name: "16-20", unlocked: false, price: 1000, id: 3))
        modelContext.insert(Pack(name: "21-25", unlocked: false, price: 1300, id: 4))

        
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
