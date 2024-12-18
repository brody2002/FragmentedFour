//
//  HomeView.swift
//  FragmentedFour
//
//  Created by Brody on 12/5/24.
//


import AVFoundation
import SwiftData
import SwiftUI

import SwiftUIIntrospect
import NavigationTransitions
// from https://github.com/davdroman/swiftui-navigation-transitions

struct HomeView: View {
    @State private var screen = UIScreen.main.bounds
    
    
    // Navigation
    @State var navPath = NavigationPath()
    
    // SwiftData
    @Query(sort: [SortDescriptor(\Level.level)]) var levels: [Level]
    @Environment(\.modelContext) var modelContext
    @EnvironmentObject var userData: UserData
    @EnvironmentObject var globalAudio: GlobalAudioSettings
    
    // Previewable Game
    let gridLayout = Array(repeating:  GridItem.init(.flexible(minimum: 50, maximum: 100)), count: 4)
    @State var currentLevel: Level?
    @State var levelTiles: [[String]]?
    @State var wordTiles = [String]()
    
    // Audio Player
    @State var audioPlayer: AVAudioPlayer?
    
    // Verision Control
    @Binding var firstLoad: Bool
    @Binding var update1_1_0: Bool
    @Binding var lastLoadedVersion: String
    
    
    
    var body: some View {
        ZStack{
            AppColors.body.ignoresSafeArea()
            NavigationStack(path: $navPath){
                ZStack{
                    AppColors.coreBlue.ignoresSafeArea()
                    VStack{
                        Spacer()
                        Spacer()
                        AppColors.body.ignoresSafeArea()
                            .frame(height: UIScreen.main.bounds.height * 0.689)
                    }
                    VStack{
                        Spacer()
                            .frame(height: UIScreen.main.bounds.height * 0.025)
                        HStack{
                            VStack{
                                Image(systemName: globalAudio.backgroundAudioOn == true ? "speaker.wave.3.fill" : "speaker.slash.fill")
                                    .resizable()
                                    .frame(width: 40, height: 40)
                                    .foregroundStyle(.white)
                                    .padding(.leading, 20)
                                    .background(
                                        Image(systemName: globalAudio.backgroundAudioOn == true ? "speaker.wave.3.fill" : "speaker.slash.fill")
                                            .resizable()
                                            .frame(width: 40, height:40)
                                            .foregroundStyle(.gray)
                                            .padding(.leading, 20)
                                            .offset(y:4)
                                    )
                                
                                    .onTapGesture {
                                        // Toggle Volume on and off
                                        globalAudio.backgroundAudioOn.toggle()
                                        
                                        if globalAudio.backgroundAudioOn == false {
                                            globalAudio.setVolume(forAll: 0.0)
                                        } else { globalAudio.setVolume(forAll: 1.0) }
                                    }
                                Spacer()
                                    .frame(height: 30)
                                ZStack {
                                    if globalAudio.soundEffectAudioOn {
                                        Image(systemName: "hand.tap.fill")
                                            .resizable()
                                            .frame(width: 40, height: 40)
                                            .foregroundStyle(.white)
                                            .padding(.leading, 20)
                                            .background(
                                                Image(systemName: "hand.tap.fill")
                                                    .resizable()
                                                    .frame(width: 40, height: 40)
                                                    .foregroundStyle(.gray)
                                                    .padding(.leading, 20)
                                                    .offset(y: 3)
                                            )
                                    }
                                    else {
                                        handTapOffView(isBackgroundView: false, isHomeScreen: true)
                                            .padding(.leading, 20)
                                            .background(
                                                handTapOffView(isBackgroundView: true, isHomeScreen: true)
                                                    .padding(.leading, 20)
                                                    .offset(y: 3)
                                            )
                                    }
                                }
                                .onTapGesture {
                                    globalAudio.soundEffectAudioOn.toggle()
                                }
                            }
                            Spacer()
                        }
                        Spacer()
                        
                    }
                    VStack{
                        HStack(alignment: .firstTextBaseline){
                            
                            Spacer()
                            
                            VStack(alignment: .trailing) {
                                Text("Fragment")
                                    .foregroundStyle(.white)
                                    .font(.system(size: 50).bold())
                                    .multilineTextAlignment(.trailing)
                                    .background(
                                        Text("Fragment")
                                            .foregroundStyle(.gray)
                                            .font(.system(size: 50).bold())
                                            .multilineTextAlignment(.trailing)
                                            .offset(y:4)
                                    )
                                
                                Spacer()
                                    .frame(height: 5)
                                
                                Text("4")
                                    .foregroundStyle(.white)
                                    .font(.system(size: 50).bold())
                                    .multilineTextAlignment(.trailing)
                                    .background(
                                        Text("4")
                                            .foregroundStyle(.gray)
                                            .font(.system(size: 50).bold())
                                            .multilineTextAlignment(.trailing)
                                            .offset(y:4)
                                    )
                            }
                            .padding(.horizontal)
                        }
                        .frame(height: screen.height * 0.17)
                        Spacer()
                            .frame(height: screen.height * 0.02)
                        
                        HStack(alignment: .top){
                            Spacer()
                            
                            //Level Select Button
                            Button(
                                action: {
                                    // Level Select
                                    globalAudio.playSoundEffect(for: "BackBubble", audioPlayer: &audioPlayer)
                                    navPath.append(DestinationStruct.Destination.selectLevel)
                                },
                                label: {
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(.white)
                                        .overlay(
                                            Text("Level Select")
                                                .foregroundStyle(.black)
                                                .bold()
                                                .clipShape(.rect(cornerRadius: 10))
                                        )
                                }
                            )
                            .buttonStyle(NoGrayOutButtonStyle())
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(.gray)
                                    .offset(y:4)
                            )
                            
                            Spacer()
                                .frame(width: 10)
                            Button(
                                action: {
                                    // Store
                                    globalAudio.playSoundEffect(for: "BackBubble", audioPlayer: &audioPlayer)
                                    navPath.append(DestinationStruct.Destination.store)
                                    
                                },
                                label: {
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(.white)
                                        .overlay(
                                            Text("Store")
                                                .bold()
                                                .foregroundStyle(.black)
                                                .clipShape(.rect(cornerRadius: 10))
                                        )
                                }
                                
                            )
                            .buttonStyle(NoGrayOutButtonStyle())
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(.gray)
                                    .offset(y: 4)
                                
                            )
                            .buttonStyle(NoGrayOutButtonStyle())
                            Spacer()
                        }
                        .padding(.horizontal)
                        .frame(height: 30)
                        Spacer()
                            .frame(height: 50)
                        
                        HStack{
                            ZStack(alignment: .leading){
                                Text("Level ___") // Hidden Level PlaceHolder
                                    .font(.title.bold())
                                    .background(
                                        RoundedRectangle(cornerRadius: 10)
                                            .fill(Color.gray.opacity(0.3))
                                            .frame(height: UIScreen.main.bounds.height * 0.06)
                                        
                                    )
                                    .hidden()
                                if let level = currentLevel?.level {
                                    ZStack{
                                        Text("Level \(level + 1)")
                                            .foregroundStyle(.white)
                                            .font(.title.bold())
                                            .fontDesign(.rounded)
                                            .background(
                                                Text("Level \(level + 1)")
                                                    .foregroundStyle(.gray)
                                                    .font(.title.bold())
                                                    .fontDesign(.rounded)
                                                    .offset(y:3)
                                            )
                                    }
                                    .padding()
                                    .background(
                                        RoundedRectangle(cornerRadius: 10)
                                            .fill(AppColors.coreBlue)
                                            .frame(height: UIScreen.main.bounds.height * 0.06)
                                        
                                    )
                                    
                                }
                            }
                            .offset(y: UIScreen.main.bounds.height * 0.06)
                            
                            
                            Spacer()
                            Spacer()
                            ZStack{
                                Circle()
                                    .fill(.white)
                                    .frame(width: 120, height: 120)
                                    .overlay(
                                        ZStack{
                                            Image(systemName: "book")
                                                .resizable()
                                                .frame(width: 70, height: 70)
                                            Image(systemName: "hand.point.up.fill")
                                                .resizable()
                                                .frame(width: 40, height: 40)
                                                .foregroundStyle(AppColors.coreBlue)
                                                .offset(x: 25, y: 20)
                                            
                                        }
                                    )
                                    .background(
                                        Circle()
                                            .fill(.gray)
                                            .frame(width: 120, height: 120)
                                            .offset(y: 4)
                                        
                                    )
                                    .onTapGesture {
                                        globalAudio.playSoundEffect(for: "BackBubble", audioPlayer: &audioPlayer)
                                        navPath.append(DestinationStruct.Destination.tutorial)
                                        
                                    }
                            }
                            .offset(y: UIScreen.main.bounds.height * 0.02)
                            
                        }
                        .padding(.horizontal)
                        Spacer()
                            .frame(height: 30)
                        RoundedRectangle(cornerRadius: 10)
                            .fill(AppColors.body)
                            .overlay(
                                ZStack{
                                    LazyVGrid(columns: gridLayout) {
                                        ForEach(wordTiles, id: \.self){ tile in
                                            TileView(
                                                text: tile,
                                                isSelected: false,
                                                isHighlighted: false,
                                                mainColor: AppColors.coreBlue,
                                                forMainMenu: false
                                            )
                                            .bold()
                                            .font(.system(size: 22))
                                            
                                        }
                                    }
                                }
                                    .offset(y: -4)
                                
                                
                                
                            )
                        
                            .padding(.horizontal)
                            .frame(height: screen.height * 0.3)
                        Spacer()
                            .frame(height: 15)
                        RoundedRectangle(cornerRadius: 10)
                            .fill(.white)
                            .overlay(
                                Text("Proceed Current Level")
                                    .foregroundStyle(.black)
                                    .bold()
                            )
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(.gray)
                                    .offset(y: 4)
                            )
                            .padding(.horizontal)
                            .frame(height: screen.height * 0.05)
                            .onTapGesture {
                                globalAudio.playSoundEffect(for: "BackBubble", audioPlayer: &audioPlayer)
                                navPath.append(DestinationStruct.Destination.levelDestination(level: currentLevel!, comingFromFastTravel: true))
                            }
                        Spacer()
                    }
                }
                .task{
                    // Check Version Number of App
                    print("firstLoad -> \(firstLoad)")
                    print("needs 1.1.0 -> \(update1_1_0)")
                    
                    let currentVersion: String = (Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String) ?? "1" // Should be 1.1
                    if lastLoadedVersion.compare(currentVersion, options: .numeric) == .orderedAscending{
                        initializeVersion1_1_0()
                    }
                    
                   
                    
                    initializeAppData()
                    
                    print("after intialLoad")
                    print("firstLoad -> \(firstLoad)")
                    print("needs 1.1.0 -> \(update1_1_0)")
                    
                    
                    
                    
                    
                    // Manage Audio on Start Up
                    if globalAudio.audioPlayerList.count == 0 { globalAudio.playMusic(for: "BackgroundMusic", backgroundMusic: true) }
                    
                    // HomeView Level Preview
                    currentLevel = userData.findCurrentLevel(levels: levels)
                    print("currentLevel \(currentLevel!.level) Score: \(currentLevel!.score) Unlocked? \(currentLevel!.unlocked)")
                    
                    if let loadedTiles: [[String]] = Bundle.main.decode("levels.json"),
                       currentLevel!.level < loadedTiles.count {
                        levelTiles = loadedTiles
                        let mixedTiles = loadedTiles[currentLevel!.level].shuffled() // shuffle before animation
                        withAnimation {
                            wordTiles = mixedTiles
                        }
                    } else {
                        levelTiles = []
                        wordTiles = []
                        print("Failed to load level tiles or current level is out of bounds.")
                    }
                    
                    //                    wordTiles =     ["cr","oss","ro","ad","hap","pi","ne","ss","ima","gin","ati","on","sk","ate","bo","ard","pu","zz","le","rs"]
                    
                    
                }
                .onDisappear{
                    wordTiles = [] // doing this gets rid of the shuffle effect every time i go back into view
                }
                
                .navigationDestination(for: DestinationStruct.Destination.self, destination: { dest in
                    switch dest{
                    case .selectLevel: // For for level select
                        LevelView(navPath: $navPath)
                    case .levelDestination(let level, let comingFromFastTravel):
                        if comingFromFastTravel {
                            ContentView(score: level.score, currentLevel: level.level, foundWords: level.foundWords, foundQuartiles: level.foundQuartiles, navPath: $navPath)
                        }
                        else {
                            ContentView(score: level.score, currentLevel: level.level, foundWords: level.foundWords, foundQuartiles: level.foundQuartiles, navPath: $navPath)
                        }
                    case .store:
                        StoreView()
                    case .tutorial:
                        TutorialView()
                    }
                })
            }
            .navigationTransition(
                .customZoom.animation(.interpolatingSpring(stiffness: 200, damping: 20))
            )
            
        }
        .fontDesign(.rounded)
        
    }
    
    func initializeAppData() {
        guard firstLoad else { return } // Check if first load is necessary
        print("Initializing app data for first launch...")
        let levels: [[String]] = Bundle.main.decode("levels.json")
        
        // Clear modelContext just in case...
        do {
            let existingLevels: [Level] = try modelContext.fetch(FetchDescriptor<Level>())
            let existingPacks: [Pack] = try modelContext.fetch(FetchDescriptor<Pack>())
            
            
            for level in existingLevels {
                modelContext.delete(level)
            }
            
            for pack in existingPacks {
                modelContext.delete(pack)
            }
            
            // Save after deletion to persist the cleared context
            try modelContext.save()
            print("Existing data cleared.")
        } catch {
            print("Failed to clear existing data: \(error)")
        }
        
        
        //Load Levels in context
        for (index, _) in levels.enumerated() {
            if index == 0 {
                modelContext.insert(Level(level: index,
                                          foundWords: [[String]](),
                                          foundQuartiles: [String](),
                                          completed: false,
                                          rank: "Novice",
                                          score: 0,
                                          unlocked: true))
                
            } else {
                if (1...4).contains(index){
                    modelContext.insert(Level(level: index,
                                              foundWords: [[String]](),
                                              foundQuartiles: [String](),
                                              completed: false,
                                              rank: "Novice",
                                              score: 0,
                                              unlocked: false))
                } else{
                    modelContext.insert(Level(level: index,
                                              foundWords: [[String]](),
                                              foundQuartiles: [String](),
                                              completed: false,
                                              rank: "Novice",
                                              score: 0,
                                              unlocked: false,
                                              redeemed: false))
                }
                
            }
            print("Level \(index) inserted...")
        }
        print("\nInserted Levels 1-50\n")
        
        // Insert Packs to the model Context
        modelContext.insert(Pack(name: "6-10", unlocked: false, price: 200, id: 1, levels: [5, 6, 7, 8, 9]))
        modelContext.insert(Pack(name: "11-15", unlocked: false, price: 600, id: 2, levels: [10, 11, 12, 13, 14]))
        modelContext.insert(Pack(name: "16-20", unlocked: false, price: 1000, id: 3, levels: [15, 16, 17, 18, 19]))
        modelContext.insert(Pack(name: "21-25", unlocked: false, price: 1300, id: 4, levels: [20, 21, 22, 23, 24]))
        
        modelContext.insert(Pack(name: "26-30", unlocked: false, price: 1850, id: 5, levels: [25, 26, 27, 28, 29]))
        modelContext.insert(Pack(name: "31-35", unlocked: false, price: 2350, id: 6, levels: [30, 31, 32, 33, 34]))
        modelContext.insert(Pack(name: "36-40", unlocked: false, price: 2850, id: 7, levels: [35, 36, 37, 38, 39]))
        modelContext.insert(Pack(name: "41-45", unlocked: false, price: 3300, id: 8, levels: [40, 41, 42, 43, 44]))
        modelContext.insert(Pack(name: "46-50", unlocked: false, price: 3700, id: 9, levels: [45, 46, 47, 48, 49]))
        print("\nInserted Packs 1-50\n")
        
        // Save the context to persist the data
        do {
            try modelContext.save()
            print("Data initialized and saved successfully.")
        } catch {
            print("Failed to save context: \(error)")
        }
        print(modelContext.container)
        
        firstLoad = false
        update1_1_0 = false // no need for udpate
        
    }
    // How to handle for firstload users and current users
    func initializeVersion1_1_0 () {
        print("Checking for update? ")
        guard firstLoad == false && update1_1_0 else { return } // if isn't first load and it needs update 1.1.0
        print("Updating and Injecting new levels/packs for version 1.1.0 ")
        
        // Load Levels in context for levels 26 through 50
        // Reminder: (0 indexed!)
        for index in 25...49 {
            modelContext.insert(Level(level: index,
                                      foundWords: [[String]](),
                                      foundQuartiles: [String](),
                                      completed: false,
                                      rank: "Novice",
                                      score: 0,
                                      unlocked: false,
                                      redeemed: false))
            
            print("Level \(index) inserted... from version update function")
        }
        // Insert Packs
        modelContext.insert(Pack(name: "26-30", unlocked: false, price: 1850, id: 5, levels: [25, 26, 27, 28, 29]))
        modelContext.insert(Pack(name: "31-35", unlocked: false, price: 2350, id: 6, levels: [30, 31, 32, 33, 34]))
        modelContext.insert(Pack(name: "36-40", unlocked: false, price: 2850, id: 7, levels: [35, 36, 37, 38, 39]))
        modelContext.insert(Pack(name: "41-45", unlocked: false, price: 3300, id: 8, levels: [40, 41, 42, 43, 44]))
        modelContext.insert(Pack(name: "46-50", unlocked: false, price: 3700, id: 9, levels: [45, 46, 47, 48, 49]))
        print("\nInserted Levels 26-50\n")
        
        // Fetch Levels that were changed and reset score and saved data.
        let level10 = fetchLevel(levelNumber: 9, context: modelContext)
        let level13 = fetchLevel(levelNumber: 12, context: modelContext)
        resetLevel(level10)
        resetLevel(level13)
        
        update1_1_0 = false
        lastLoadedVersion = "1.1.0"
        
    }
    
    func fetchLevel(levelNumber: Int, context: ModelContext) -> Level? {
        let descriptor = FetchDescriptor<Level>(
            predicate: #Predicate { $0.level == levelNumber }
        )
        do {
            let results = try context.fetch(descriptor)
            return results.first // Return the first match, or nil if not found
        } catch {
            print("Failed to fetch level: \(error)")
            return nil
        }
    }
    
    func resetLevel(_ inputLevel: Level?) {
        guard let inputLevel = inputLevel else { return }
        inputLevel.score = 0
        inputLevel.levelThreshhold = 15
        inputLevel.completed = false
        inputLevel.foundAllWords = false
        inputLevel.foundQuartiles = [String]()
        inputLevel.foundWords = [[String]]()
        inputLevel.rank = "Novice"
    }
    
}

extension View {
    func disableSwipeBack() -> some View {
        self.background(
            DisableSwipeBackView()
        )
    }
}

struct DisableSwipeBackView: UIViewControllerRepresentable {
    
    typealias UIViewControllerType = DisableSwipeBackViewController
    
    
    func makeUIViewController(context: Context) -> UIViewControllerType {
        UIViewControllerType()
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
    }
}

class DisableSwipeBackViewController: UIViewController {
    
    override func didMove(toParent parent: UIViewController?) {
        super.didMove(toParent: parent)
        if let parent = parent?.parent,
           let navigationController = parent.navigationController,
           let interactivePopGestureRecognizer = navigationController.interactivePopGestureRecognizer {
            navigationController.view.removeGestureRecognizer(interactivePopGestureRecognizer)
        }
    }
}



#Preview {
    @Previewable @StateObject var globalAudio = GlobalAudioSettings()
    let config = ModelConfiguration(for: Level.self, Pack.self, isStoredInMemoryOnly: true)
    
    let container = try! ModelContainer(for: Level.self, Pack.self, configurations: config)
    
    let userData = UserData()
    
    container.mainContext.insert(Level(level: 0, foundWords: [[String]](), foundQuartiles: [String](), completed: false, rank: "Novice", score: 0, unlocked: true))
    container.mainContext.insert(Level(level: 1, foundWords: [[String]](), foundQuartiles: [String](), completed: false, rank: "Novice", score: 0, unlocked: false))
    container.mainContext.insert(Level(level: 2, foundWords: [[String]](), foundQuartiles: [String](), completed: false, rank: "Novice", score: 0, unlocked: false))
    container.mainContext.insert(Level(level: 3, foundWords: [[String]](), foundQuartiles: [String](), completed: false, rank: "Novice", score: 0, unlocked: false))
    container.mainContext.insert(Level(level: 4, foundWords: [[String]](), foundQuartiles: [String](), completed: false, rank: "Novice", score: 0, unlocked: false))
    container.mainContext.insert(Level(level: 5, foundWords: [[String]](), foundQuartiles: [String](), completed: false, rank: "Novice", score: 0, unlocked: false))
    container.mainContext.insert(Level(level: 1, foundWords: [[String]](), foundQuartiles: [String](), completed: false, rank: "Novice", score: 0, unlocked: false, redeemed: false))
    
    container.mainContext.insert(Pack(name: "6-10", unlocked: false, price: 200, id: 1, levels: [5, 6, 7, 8, 9]))
    container.mainContext.insert(Pack(name: "11-15", unlocked: false, price: 600, id: 2, levels: [10, 11, 12, 13, 14]))
    container.mainContext.insert(Pack(name: "16-20", unlocked: false, price: 1000, id: 3, levels: [15, 16, 17, 18, 19]))
    container.mainContext.insert(Pack(name: "21-25", unlocked: false, price: 1300, id: 4, levels: [20, 21, 22, 23, 24]))
    
    
    return HomeView(firstLoad: .constant(false), update1_1_0: .constant(true), lastLoadedVersion: .constant("1.0"))
        .modelContainer(container)
        .environmentObject(userData)
        .environmentObject(globalAudio)
    
    
    
    
}
