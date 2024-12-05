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
    @State private var shakeStates: [Int: Bool] = [:]
    // Define the levels as a range for simplicity
    
    // Define the grid layout
    let columns = [
            GridItem(.flexible(), spacing: 40), // Add horizontal spacing between columns
            GridItem(.flexible(), spacing: 40),
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
                                                        Text("Total Words") //place holder score for now
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
                        LazyVGrid(columns: columns, spacing: 40) {
                            ForEach(levels, id: \.level){ level in
                                LevelTileView(level: level.level, completed: level.completed, unlocked: level.unlocked, score:  level.score, redeemed: level.redeemed)
                                    .matchedTransitionSource(id: level.level, in: animationNamespace)
                                    .onTapGesture {
                                        if level.unlocked{
                                            GlobalAudioSettings.shared.playSoundEffect(for: "BackBubble", audioPlayer: &audioPlayer)
                                            navPath.append(Destination.levelDestination(level: level))
                                        } else if !level.unlocked && level.redeemed {
                                            shakeStates[level.level] = true
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8){
                                                shakeStates[level.level] = false
                                            }
                                        }
                                    }
//                                    .disabled(!level.unlocked)
                                    .background(
                                        ZStack{
                                            if level.redeemed {
                                                RoundedRectangle(cornerRadius: 10)
                                                    .fill(.gray.opacity(0.5))
                                                    .offset(y: 4)
                                                    .frame(width: 120, height: 80)
                                            }
                                        }
                                    )
                                    .frame(width: 120, height: 80)
                                    .shakeEffect(
                                        trigger: shakeStates[level.level] ?? false,
                                        distance: 7,
                                        animationDuration: 0.08,
                                        initialDelay: 0.0
                                    )
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
                GlobalAudioSettings.shared.playMusic(for: "BackgroundMusic", backgroundMusic: true)
            }
            else { print("audio off ") }
            
            
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
        container.mainContext.insert(Level(level: 6, foundWords: [[]], foundQuartiles: [], completed: false, rank: "Master", score: 101, unlocked: false, redeemed: false))
        return LevelView()
            .modelContainer(container)
            .environmentObject(userData)
    } catch {
        return Text("Failed to create container: \(error.localizedDescription)")
    }
}
