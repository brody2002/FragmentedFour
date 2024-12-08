//
//  HomeView.swift
//  FragmentedFour
//
//  Created by Brody on 12/5/24.
//


import AVFoundation
import SwiftData
import SwiftUI



struct HomeView: View {
    @State private var screen = UIScreen.main.bounds
    
    // Navigation
    @State var navPath = NavigationPath()
    @Namespace var levelSelectAnimation
    @Namespace var levelGameAnimation
    @Namespace var storeAnimation
    
    // SwiftData
    @Query(sort: [SortDescriptor(\Level.level)]) var levels: [Level]
    @Environment(\.modelContext) var modelContext
    @EnvironmentObject var userData: UserData
    
    // Previewable Game
    let gridLayout = Array(repeating:  GridItem.init(.flexible(minimum: 50, maximum: 100)), count: 4)
    @State var currentLevel: Level?
    @State var levelTiles: [[String]]?
    @State var wordTiles = [String]()
    
    // Audio Player
    @State var audioPlayer: AVAudioPlayer?
    
    
    var body: some View {
        ZStack{
            AppColors.coreBlue.ignoresSafeArea()
            NavigationStack(path: $navPath){
                ZStack{
                    AppColors.coreBlue.ignoresSafeArea()
                    
                    VStack{
                        HStack(alignment: .firstTextBaseline){
                            VStack{
                                HStack{
                                    Image(systemName: "equal")
                                        .resizable()
                                        .frame(width: 40, height: 20)
                                        .foregroundStyle(.white)
                                        .padding(.leading, 20)
                                        .background(
                                            Image(systemName: "equal")
                                                .resizable()
                                                .frame(width: 40, height: 20)
                                                .foregroundStyle(.gray)
                                                .padding(.leading, 20)
                                                .offset(y:2)
                                        )
                                        .onTapGesture {
                                            GlobalAudioSettings.shared.playSoundEffect(for: "BackBubble", audioPlayer: &audioPlayer)
                                        }
                                }
                                
                            }
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
                                
                                Text("Four")
                                    .foregroundStyle(.white)
                                    .font(.system(size: 50).bold())
                                    .multilineTextAlignment(.trailing)
                                    .background(
                                        Text("Four")
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
                            .frame(height: 20)
                        
                        HStack(alignment: .top){
                            Spacer()
                            
                            //Level Select Button
                            Button(
                                action: {
                                    // Level Select
                                    GlobalAudioSettings.shared.playSoundEffect(for: "BackBubble", audioPlayer: &audioPlayer)
                                    navPath.append(DestinationStruct.Destination.selectLevel(animation: levelSelectAnimation ))
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
                            .matchedTransitionSource(id: "levelSelect", in: levelSelectAnimation)
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
                                    GlobalAudioSettings.shared.playSoundEffect(for: "BackBubble", audioPlayer: &audioPlayer)
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
                            .matchedTransitionSource(id: "store", in: levelSelectAnimation)
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
                            .frame(height: 30)
                        
                        HStack{
                            Spacer()
                            Spacer()
                            Circle()
                                .fill(.white)
                                .frame(width: 160, height: 160)
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
                                        .frame(width: 160, height: 160)
                                        .offset(y: 4)
                                        
                                )
                                .onTapGesture {
                                    GlobalAudioSettings.shared.playSoundEffect(for: "BackBubble", audioPlayer: &audioPlayer)
                                }
                        }
                        .padding(.horizontal)
                        Spacer()
                            .frame(height: 20)
                        RoundedRectangle(cornerRadius: 10)
                            .fill(AppColors.body)
                            .overlay(
                                
                                LazyVGrid(columns: gridLayout) {
                                    ForEach(wordTiles, id: \.self){ tile in
                                        TileView(
                                            text: tile,
                                            isSelected: false,
                                            isHighlighted: false,
                                            mainColor: AppColors.coreBlue
                                        )
                                        .bold()
                                        .font(.system(size: 22))
                                        
                                    }
                                }
                                
                                
                            )
                            .matchedTransitionSource(id: "levelView", in: levelGameAnimation)
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(.gray)
                                    .offset(y: 4)
                                
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
                                GlobalAudioSettings.shared.playSoundEffect(for: "BackBubble", audioPlayer: &audioPlayer)
                                navPath.append(DestinationStruct.Destination.levelDestination(level: currentLevel!, animation: levelGameAnimation))
                            }
                        Spacer()
                    }
                }
                .task{
                    print("Loaded levels: \(levels.count)")
                        for level in levels {
                            print("Level \(level.level) - Rank: \(level.rank)")
                        }
                    if GlobalAudioSettings.shared.audioOn && GlobalAudioSettings.shared.playingBackgroundMusic == false{
                        print("attempt to play audio ")
                        GlobalAudioSettings.shared.playMusic(for: "BackgroundMusic", backgroundMusic: true)
                        GlobalAudioSettings.shared.playingBackgroundMusic = true
                    } else {
                        print("not playing background music ")
                    }
                    currentLevel = userData.findCurrentLevel(levels: levels)
                    
                    if let loadedTiles: [[String]] = Bundle.main.decode("levels.txt"),
                       currentLevel!.level < loadedTiles.count {
                        levelTiles = loadedTiles
                        wordTiles = loadedTiles[currentLevel!.level]
                    } else {
                        levelTiles = []
                        wordTiles = []
                        print("Failed to load level tiles or current level is out of bounds.")
                    }
                    
                }
                .navigationDestination(for: DestinationStruct.Destination.self, destination: { dest in
                    switch dest{
                    case .selectLevel(let animation):
                        LevelView(navPath: $navPath)
                            .navigationTransition(.zoom(sourceID: "levelSelect", in: animation))
                    case .levelDestination(let level, let animation):
                        ContentView(score: level.score, currentLevel: level.level, foundWords: level.foundWords, foundQuartiles: level.foundQuartiles, animation: animation, navPath: $navPath)
                            .navigationTransition(.zoom(sourceID: "levelView", in: animation))
                    case .store:
                        StoreView()
                            .navigationTransition(.zoom(sourceID: "store", in: storeAnimation))
                    }
                })
            }
        }
        
    }
    
    
}

#Preview {
    
        let config = ModelConfiguration(for: Level.self, Pack.self) 
        let container = try! ModelContainer(for: Level.self, Pack.self, configurations: config)
        let userData = UserData()
        container.mainContext.insert(Level(level: 0, foundWords: [[String]](), foundQuartiles: [String](), completed: false, rank: "Novice", score: 0, unlocked: true))
        container.mainContext.insert(Level(level: 1, foundWords: [[String]](), foundQuartiles: [String](), completed: false, rank: "Novice", score: 0, unlocked: true))
        container.mainContext.insert(Level(level: 2, foundWords: [[String]](), foundQuartiles: [String](), completed: false, rank: "Novice", score: 0, unlocked: true))
        container.mainContext.insert(Level(level: 3, foundWords: [[String]](), foundQuartiles: [String](), completed: false, rank: "Novice", score: 0, unlocked: true))
        container.mainContext.insert(Level(level: 4, foundWords: [[String]](), foundQuartiles: [String](), completed: false, rank: "Novice", score: 0, unlocked: true))
        container.mainContext.insert(Level(level: 5, foundWords: [[String]](), foundQuartiles: [String](), completed: false, rank: "Novice", score: 0, unlocked: true))
        container.mainContext.insert(Level(level: 1, foundWords: [[String]](), foundQuartiles: [String](), completed: false, rank: "Novice", score: 0, unlocked: true, redeemed: false))
    
    container.mainContext.insert(Pack(name: "6-10", unlocked: false, price: 200, id: 1))
    container.mainContext.insert(Pack(name: "11-15", unlocked: false, price: 600, id: 2))
    container.mainContext.insert(Pack(name: "16-20", unlocked: false, price: 1000, id: 3))
    container.mainContext.insert(Pack(name: "21-25", unlocked: false, price: 1300, id: 4))
        

        return HomeView()
            .modelContainer(container)
            .environmentObject(userData)
    
}
