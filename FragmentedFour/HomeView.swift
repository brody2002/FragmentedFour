//
//  HomeView.swift
//  FragmentedFour
//
//  Created by Brody on 12/5/24.
//

import SwiftData
import SwiftUI


struct HomeView: View {
    @State private var screen = UIScreen.main.bounds
    
    // Navigation
    @State var navPath = NavigationPath()
    
    // SwiftData
    @Query(sort: [SortDescriptor(\Level.level)]) var levels: [Level]
    @Environment(\.modelContext) var modelContext
    
    var body: some View {
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
                        Button(
                            action: {
                                // Level Select
                                navPath.append(DestinationStruct.Destination.selectLevel)
                            },
                            label: {
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(.white)
                                    .background(
                                        RoundedRectangle(cornerRadius: 10)
                                            .fill(.gray.opacity(0.4))
                                    )
                                    .overlay(
                                        Text("Level Select")
                                            .foregroundStyle(.black)
                                            .bold()
                                    )
                            }
                        )
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(.gray)
                                .offset(y: 4)
                        )
                        .buttonStyle(NoGrayOutButtonStyle())
                        Spacer()
                            .frame(width: 10)
                        Button(
                            action: {
                                // Store
                            },
                            label: {
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(.white)
                                    .background(
                                        RoundedRectangle(cornerRadius: 10)
                                            .fill(.gray.opacity(0.4))
                                    )
                                    .overlay(
                                        Text("Store")
                                            .bold()
                                            .foregroundStyle(.black)
                                    )
                            }
                            
                        )
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
                    RoundedRectangle(cornerRadius: 10)
                        .fill(.white)
                        .overlay(
                            // Current Word Puzzle display View
                            Text("TBD Puzzle View")
                                .foregroundStyle(.black)
                                .bold()
                        )
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
                    Spacer()
                        .frame(height: 50)
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
                    }
                    .padding(.horizontal)
                    Spacer()
                }
            }
            .task{
                if GlobalAudioSettings.shared.audioOn && GlobalAudioSettings.shared.playingBackgroundMusic == false{
                    print("attempt to play audio ")
                    GlobalAudioSettings.shared.playMusic(for: "BackgroundMusic", backgroundMusic: true)
                    GlobalAudioSettings.shared.playingBackgroundMusic = true
                } else {
                    print("not playing background music ")
                }
            }
            // nav dest
            .navigationDestination(for: DestinationStruct.Destination.self, destination: { dest in
                switch dest{
                case .selectLevel:
                    LevelView(navPath: $navPath)
                case .levelDestination(let level, let animation):
                    ContentView(score: level.score, currentLevel: level.level, foundWords: level.foundWords, foundQuartiles: level.foundQuartiles, animation: animation)
                        .navigationTransition(.zoom(sourceID: level.level, in: animation))
                }
                
            })
        }
        
    }
}

#Preview {
    
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try! ModelContainer(for: Level.self, configurations: config)
        let userData = UserData()
        container.mainContext.insert(Level(level: 0, foundWords: [[String]](), foundQuartiles: [String](), completed: false, rank: "Novice", score: 0, unlocked: true))
        container.mainContext.insert(Level(level: 1, foundWords: [[String]](), foundQuartiles: [String](), completed: false, rank: "Novice", score: 0, unlocked: true))
        container.mainContext.insert(Level(level: 2, foundWords: [[String]](), foundQuartiles: [String](), completed: false, rank: "Novice", score: 0, unlocked: true))
        container.mainContext.insert(Level(level: 3, foundWords: [[String]](), foundQuartiles: [String](), completed: false, rank: "Novice", score: 0, unlocked: true))
        container.mainContext.insert(Level(level: 4, foundWords: [[String]](), foundQuartiles: [String](), completed: false, rank: "Novice", score: 0, unlocked: true))
        container.mainContext.insert(Level(level: 5, foundWords: [[String]](), foundQuartiles: [String](), completed: false, rank: "Novice", score: 0, unlocked: true))
        container.mainContext.insert(Level(level: 1, foundWords: [[String]](), foundQuartiles: [String](), completed: false, rank: "Novice", score: 0, unlocked: true, redeemed: false))
        

        return HomeView()
            .modelContainer(container)
            .environmentObject(userData)
    
}
