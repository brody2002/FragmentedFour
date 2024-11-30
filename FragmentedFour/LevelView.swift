//
//  LevelView.swift
//  FragmentedFour
//
//  Created by Brody on 11/29/24.
//


import SwiftUI
import SwiftData

struct LevelView: View {
    @State var navPath = NavigationPath()
    @Environment(\.modelContext) var modelContext
    @Query(sort: [SortDescriptor(\Level.level)]) var levels: [Level]
    
    // Define the levels as a range for simplicity
    
    // Define the grid layout
    let columns = [
            GridItem(.flexible(), spacing: 20), // Add horizontal spacing between columns
            GridItem(.flexible(), spacing: 20),
            GridItem(.flexible(), spacing: 20)
    ]
    
    enum Destination: Hashable{
        case levelDestination(level: Level)
        
    }
    
    var body: some View {
        NavigationStack(path: $navPath){
            ZStack{
                AppColors.body.ignoresSafeArea()
                
                VStack{
                    ZStack{
                        Color.blue.ignoresSafeArea()
                        VStack{
                            ZStack(alignment: .top){
                                VStack{
                                    Text("Level Select")
                                        .foregroundStyle(.white)
                                        .font(.title.bold())
                                    
                                    Image(systemName: "flag.2.crossed")
                                        .resizable()
                                        .frame(width: 140, height : 80)
                                        .foregroundStyle(.white)
                                    
                                }
                                HStack(alignment: .top){
                                    Image(systemName: "equal")
                                        .resizable()
                                        .frame(width: 40, height: 20)
                                        .foregroundStyle(.white)
                                        .padding(.leading, 20)
                                        .hidden()
        
                                    Spacer()
                                }
                            }
                            
                        }
                        
                    }
                    .frame(height: UIScreen.main.bounds.height * 0.18)
                    
                    Spacer()
                        .frame(minHeight: 50, maxHeight: 50)
                    
                    ScrollView{ // Add ScrollView for scrolling
                        LazyVGrid(columns: columns, spacing: 50) {
                            ForEach(levels, id: \.level){ level in
                                LevelTileView(level: level.level, completed: level.completed)
                                    .onTapGesture {
                                        navPath.append(Destination.levelDestination(level: level))
                                    }
                            }
                        }
                        .padding(.leading, 40)
                        .padding(.trailing, 40)// Add padding around the grid
                    }
                }
            }
            .navigationDestination(for: Destination.self, destination: { dest in
                switch dest{
                case .levelDestination(let level):
                    ContentView(score: level.score, currentLevel: level.level, foundWords: level.foundWords, foundQuartiles: level.foundQuartiles)
                }
            })
        }
       
        .task{
//             Check if it's the first launch EVER
                    if UserDefaults.standard.bool(forKey: "firstLaunchEver") == false {
                        initializeAppData()
                        // Set the flag to true so initialization doesn't run again
                        UserDefaults.standard.set(true, forKey: "firstLaunchEver")
                    }
        }
    }
    
    func initializeAppData() {
        print("Initializing app data for first launch...")
        let levels: [[String]] = Bundle.main.decode("levels.txt")
        for (index, _) in levels.enumerated() {
            modelContext.insert(Level(level: index + 1, foundWords: [[]], foundQuartiles: [], completed: false, rank: "Novice", score: 0))
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

#Preview {
    
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Level.self, configurations: config)
        container.mainContext.insert(Level(level: 1, foundWords: [[]], foundQuartiles: [], completed: false, rank: "Novice", score: 0))
        container.mainContext.insert(Level(level: 2, foundWords: [[]], foundQuartiles: [], completed: true, rank: "Master", score: 101))
        container.mainContext.insert(Level(level: 3, foundWords: [[]], foundQuartiles: [], completed: false, rank: "Master", score: 101))
        container.mainContext.insert(Level(level: 4, foundWords: [[]], foundQuartiles: [], completed: false, rank: "Master", score: 101))
        container.mainContext.insert(Level(level: 5, foundWords: [[]], foundQuartiles: [], completed: false, rank: "Master", score: 101))
        container.mainContext.insert(Level(level: 6, foundWords: [[]], foundQuartiles: [], completed: false, rank: "Master", score: 101))
        container.mainContext.insert(Level(level: 7, foundWords: [[]], foundQuartiles: [], completed: false, rank: "Master", score: 101))
        return LevelView()
            .modelContainer(container)
    } catch {
        return Text("Failed to create container: \(error.localizedDescription)")
    }
}

