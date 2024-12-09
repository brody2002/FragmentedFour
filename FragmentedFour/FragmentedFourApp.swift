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
    @AppStorage("firstLoad") private var firstLoad: Bool = true
    
    
    
    var body: some Scene {
        WindowGroup {
            ZStack{
                HomeView(firstLoad: $firstLoad)
                    
                    
            }
            .environmentObject(userData)
            .modelContainer(for: [Level.self, Pack.self])

//            .task {
//                if UserDefaults.standard.bool(forKey: "firstLaunchEver") == false {
//                    initializeAppData() // for first ever launch
//                    UserDefaults.standard.set(true, forKey: "firstLaunchEver")
//                }
//            }
        }
        
    }
//    func initializeAppData() {
//        print("Initializing app data for first launch...")
//        let levels: [[String]] = Bundle.main.decode("levels.txt")
//        //Load Levels in context
//        for (index, _) in levels.enumerated() {
//            print("inserting")
//            if index == 0 {
//                modelContext.insert(Level(level: index, foundWords: [[String]](), foundQuartiles: [String](), completed: false, rank: "Novice", score: 0, unlocked: true))
//            } else {
//                if (1...4).contains(index){
//                    modelContext.insert(Level(level: index, foundWords: [[String]](), foundQuartiles: [String](), completed: false, rank: "Novice", score: 0, unlocked: false))
//                } else{
//                    modelContext.insert(Level(level: index, foundWords: [[String]](), foundQuartiles: [String](), completed: false, rank: "Novice", score: 0, unlocked: false, redeemed: false))
//                }
//                
//            }
//            print("Level \(index) inserted...")
//        }
//        // Insert Packs to the model Context
//        modelContext.insert(Pack(name: "6-10", unlocked: false, price: 200, id: 1))
//        modelContext.insert(Pack(name: "11-15", unlocked: false, price: 600, id: 2))
//        modelContext.insert(Pack(name: "16-20", unlocked: false, price: 1000, id: 3))
//        modelContext.insert(Pack(name: "21-25", unlocked: false, price: 1300, id: 4))
//
//        
//        // Save the context to persist the data
//        do {
//            try modelContext.save()
//            print("Data initialized and saved successfully.")
//        } catch {
//            print("Failed to save context: \(error)")
//        }
//        print(modelContext.container)
//    }
}


//actor SwiftDataContainer {
//    
//    @MainActor
//    static func create(firstLoad: inout Bool) -> ModelContainer {
//        let schema = Schema([Level.self, Pack.self])
//        let config = ModelConfiguration()
//        @State var container = try! ModelContainer(for: schema, configurations: config)
//        
//        if firstLoad {
//            print("Initializing app data for first launch...")
//            let levels: [[String]] = Bundle.main.decode("levels.txt")
//            //Load Levels in context
//            for (index, _) in levels.enumerated() {
//                print("inserting")
//                if index == 0 {
//                    container.mainContext.insert(Level(level: index, foundWords: [[String]](), foundQuartiles: [String](), completed: false, rank: "Novice", score: 0, unlocked: true))
//                } else {
//                    if (1...4).contains(index){
//                        container.mainContext.insert(Level(level: index, foundWords: [[String]](), foundQuartiles: [String](), completed: false, rank: "Novice", score: 0, unlocked: false))
//                    } else{
//                        container.mainContext.insert(Level(level: index, foundWords: [[String]](), foundQuartiles: [String](), completed: false, rank: "Novice", score: 0, unlocked: false, redeemed: false))
//                    }
//                    
//                }
//                print("Level \(index) inserted...")
//            }
//            
//            // Insert Packs to the model Context
//            container.mainContext.insert(Pack(name: "6-10", unlocked: false, price: 200, id: 1))
//            container.mainContext.insert(Pack(name: "11-15", unlocked: false, price: 600, id: 2))
//            container.mainContext.insert(Pack(name: "16-20", unlocked: false, price: 1000, id: 3))
//            container.mainContext.insert(Pack(name: "21-25", unlocked: false, price: 1300, id: 4))
//            
//            do {
//                try container.mainContext.save()
//                print("Data initialized and saved successfully.")
//            } catch {
//                print("Error saveing container: couldn't save the container properly...")
//            }
//            
//            firstLoad = false
//        }
//    
//        return container
//    }
//}
