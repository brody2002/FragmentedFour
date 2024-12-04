//
//  LevelView.swift
//  FragmentedFour
//
//  Created by Brody on 11/29/24.
//

import AVFoundation
import SwiftUI
import SwiftData

struct LevelView: View {
    @State var navPath = NavigationPath()
    @Environment(\.modelContext) var modelContext
    @Query(sort: [SortDescriptor(\Level.level)]) var levels: [Level]
    @Namespace private var animationNamespace
    @EnvironmentObject var userData: UserData
    @State private var audioPlayer: AVAudioPlayer?
    @State private var mainColor: Color = AppColors.coreBlue
    
    // Define the levels as a range for simplicity
    
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
                        mainColor.ignoresSafeArea()
                        VStack{
                            ZStack(alignment: .top){
                                VStack{
                                    Text("Level Select")
                                        .foregroundStyle(.white)
                                        .font(.system(size: 40).bold())
                                        .offset(y: 54)
                                    
                                        
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(Color.white)
                                        .frame(width: UIScreen.main.bounds.width * 0.84, height: UIScreen.main.bounds.height * 0.10)
                                        .overlay(
                                            ZStack{
                                                HStack(alignment: .top) {
                                                    VStack(alignment: .leading) {
                                                        Text("Avg Rank   ")
                                                            .bold()
                                                            .font(.system(size:14))
                                                        + Text("\(userData.avgRank)")
                                                            .bold()
                                                            .font(.system(size: 28))
                                                            .foregroundStyle(mainColor)
                                                            
                                                        Spacer()
                                                            .frame(height: 10)
                                                        Text("Total Pts") //place holder score for now
                                                            .bold()
                                                            .font(.system(size:14))
                                                        + Text("    \(userData.totalPts) 💰")
                                                            .bold()
                                                            .foregroundColor(mainColor)
                                                            .font(.system(size: 23))
                                                        Spacer()
                                                    }
                                                    .padding()
                                                    Spacer()
                                                }
                                            }
                                        )
                                        .background(
                                            RoundedRectangle(cornerRadius: 10)
                                                .frame(width: UIScreen.main.bounds.width * 0.84, height: UIScreen.main.bounds.height * 0.10)
                                                .foregroundStyle(.gray.opacity(0.4))
                                                .offset(y:4)
                                        )
                                        .offset(y: 40)
                                        
                                }
                                .padding(.bottom, 20)
                                
                                
                                
                            }
                            
                        }
                        
                    }
                    .frame(height: UIScreen.main.bounds.height * 0.08)
                    
                    Spacer()
                        .frame(height: 100)
                    
                    ScrollView{ // Add ScrollView for scrolling
                        LazyVGrid(columns: columns, spacing: 50) {
                            ForEach(levels, id: \.level){ level in
                                LevelTileView(level: level.level, completed: level.completed, unlocked: level.unlocked, score:  level.score)
                                    .onTapGesture {
                                        navPath.append(Destination.levelDestination(level: level))
                                            
                                    }
                                    .matchedGeometryEffect(id: level.level, in: animationNamespace)
                                    
                                    
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
                    ContentView(score: level.score, currentLevel: level.level, foundWords: level.foundWords, foundQuartiles: level.foundQuartiles, animation: animationNamespace)
                        .navigationTransition(.zoom(sourceID: level.level, in: animationNamespace))
                        
                        
                        
                }
            })
        }
       
        .task{
            withAnimation(.spring(response: 0.3, dampingFraction: 0.6)){
                userData.updatePtsAndRank(levels: levels)
            }
            if UserDefaults.standard.bool(forKey: "firstLaunchEver") == false {
                initializeAppData() // for first ever launch
                UserDefaults.standard.set(true, forKey: "firstLaunchEver")
            }
            
            if GlobalAudioSettings.shared.audioOn{
                print("audio is on")
                GlobalAudioSettings.shared.playSound(for: "BackgroundMusic", backgroundMusic: true)
            }
            else { print("audio off ") }
            
            
        }
    }
    
//    func playSound(for soundName: String) {
//        // Safely unwrap the URL
//        guard let url = Bundle.main.url(forResource: soundName, withExtension: "m4a") else {
//            print("Error: Could not find the sound file named \(soundName).m4a in the bundle.")
//            return
//        }
//
//        do {
//            // Try to initialize the audio player
//            audioPlayer = try AVAudioPlayer(contentsOf: url)
//            audioPlayer?.numberOfLoops = -1 // Set your desired number of loops (-1 for infinite)
//            audioPlayer?.play()
//        } catch {
//            // Print an error message in case of failure
//            print("Error: Could not play the audio file. \(error.localizedDescription)")
//        }
//    }

    
    
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
        let userData = UserData()
        container.mainContext.insert(Level(level: 0, foundWords: [[]], foundQuartiles: [], completed: false, rank: "Novice", score: 0, unlocked: false))
        container.mainContext.insert(Level(level: 1, foundWords: [[]], foundQuartiles: [], completed: true, rank: "Master", score: 101,unlocked: true))
        container.mainContext.insert(Level(level: 2, foundWords: [[]], foundQuartiles: [], completed: true, rank: "Wordsmith", score: 67, unlocked: true))
        container.mainContext.insert(Level(level: 3, foundWords: [[]], foundQuartiles: [], completed: false, rank: "Master", score: 101, unlocked: true))
        container.mainContext.insert(Level(level: 4, foundWords: [[]], foundQuartiles: [], completed: false, rank: "Master", score: 101, unlocked: true))
        container.mainContext.insert(Level(level: 5, foundWords: [[]], foundQuartiles: [], completed: false, rank: "Master", score: 101, unlocked: false))
        container.mainContext.insert(Level(level: 6, foundWords: [[]], foundQuartiles: [], completed: false, rank: "Master", score: 101, unlocked: false))
        return LevelView()
            .modelContainer(container)
            .environmentObject(userData)
    } catch {
        return Text("Failed to create container: \(error.localizedDescription)")
    }
}
