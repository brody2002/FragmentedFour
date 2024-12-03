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
    @State var userData: UserData?
    
    // FIGURE OUT FETCHING THE CLASS CORRECTLY

    
    @Namespace private var transitionNamespace
    
    @State private var totalPts: Int = 0
    @State private var levelsUnlocked: Int = 1
    
    func fetchUserData(){
        let fetchDescriptor = FetchDescriptor<UserData>(
            predicate: #Predicate { $0.id == "UserData" })
        do {
            userData = try? modelContext.fetch(fetchDescriptor)
        } catch {
            print("Failed to fetch: \(error)")
        }
    }
    
    // Define the grid layout
    let columns = [
            GridItem(.flexible(), spacing: 60), // Add horizontal spacing between columns
            GridItem(.flexible(), spacing: 60),
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
                                        .font(.system(size: 40).bold())
                                        .offset(y: 13)
                                    
                                        
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(AppColors.body)
                                        .frame(width: UIScreen.main.bounds.width * 0.84, height: UIScreen.main.bounds.height * 0.10)
                                        .overlay(
                                            ZStack{
                                                RoundedRectangle(cornerRadius: 10)
                                                    .stroke(style: StrokeStyle(lineWidth: 5))
                                                    .frame(width: UIScreen.main.bounds.width * 0.84, height: UIScreen.main.bounds.height * 0.10)
                                                    .foregroundStyle(.gray.opacity(0.4))
                                                
                                                HStack(alignment: .top) {
                                                    VStack(alignment: .leading) {
                                                        Text("Avg Rank   ")
                                                            .bold()
                                                            .font(.system(size:14))
                                                        + Text(String(userData.avgRank))
                                                            .bold()
                                                            .font(.system(size: 28))
                                                            .foregroundStyle(Color.blue)
                                                            
                                                        Spacer()
                                                            .frame(height: 10)
                                                        Text("Total Pts") //place holder score for now
                                                            .bold()
                                                            .font(.system(size:14))
                                                        + Text("   \(userData.totalPts) 💰")
                                                            .bold()
                                                            .foregroundColor(.blue)
                                                            .font(.system(size: 23))
                                                        Spacer()
                                                    }
                                                    .padding()
                                                    Spacer()
                                                        
                                                    
                                                }
                                            }
                                            
                                        )
                                        
                                }
                                .padding(.bottom, 20)
                                
                                
                                
                            }
                            
                        }
                        
                    }
                    .frame(height: UIScreen.main.bounds.height * 0.18)
                    
                    Spacer()
                        .frame(minHeight: 50, maxHeight: 50)
                    
                    ScrollView{ // Add ScrollView for scrolling
                        LazyVGrid(columns: columns, spacing: 50) {
                            ForEach(levels, id: \.level){ level in
                                LevelTileView(level: level.level, completed: level.completed, unlocked: level.unlocked, score:  level.score)
                                    .onTapGesture {
                                        navPath.append(Destination.levelDestination(level: level))
                                            
                                    }
                                    .disabled(!level.unlocked)
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
                        .navigationTransition(.zoom(sourceID: level.level, in: transitionNamespace))
                        
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
            userData.updatePtsAndRank(levels: levels)
        
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
                modelContext.insert(Level(level: index, foundWords: [[String]](), foundQuartiles: [String](), completed: false, rank: "Novice", score: 0, unlocked: false))
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

#Preview {
    
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Level.self, configurations: config)
        container.mainContext.insert(Level(level: 0, foundWords: [[]], foundQuartiles: [], completed: false, rank: "Novice", score: 0, unlocked: false))
        container.mainContext.insert(Level(level: 1, foundWords: [[]], foundQuartiles: [], completed: true, rank: "Master", score: 101,unlocked: true))
        container.mainContext.insert(Level(level: 2, foundWords: [[]], foundQuartiles: [], completed: true, rank: "Wordsmith", score: 67, unlocked: true))
        container.mainContext.insert(Level(level: 3, foundWords: [[]], foundQuartiles: [], completed: false, rank: "Master", score: 101, unlocked: true))
        container.mainContext.insert(Level(level: 4, foundWords: [[]], foundQuartiles: [], completed: false, rank: "Master", score: 101, unlocked: true))
        container.mainContext.insert(Level(level: 5, foundWords: [[]], foundQuartiles: [], completed: false, rank: "Master", score: 101, unlocked: false))
        container.mainContext.insert(Level(level: 6, foundWords: [[]], foundQuartiles: [], completed: false, rank: "Master", score: 101, unlocked: false))
        return LevelView()
            .modelContainer(container)
    } catch {
        return Text("Failed to create container: \(error.localizedDescription)")
    }
}

