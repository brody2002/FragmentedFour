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
    @Environment(\.modelContext) var modelContext
    @Query(sort: [SortDescriptor(\Level.level)]) var levels: [Level]
    @Namespace private var animationNamespace
    @EnvironmentObject var userData: UserData
    @State private var audioPlayer: AVAudioPlayer?
    @State private var mainColor: Color = AppColors.coreBlue
    @State private var shakeStates: [Int: Bool] = [:]
    @Binding var navPath: NavigationPath
    @Namespace var levelSelectionAnimation: Namespace.ID
    // Define the levels as a range for simplicity
    
    // Define the grid layout
    let columns = [
            GridItem(.flexible(), spacing: 40), // Add horizontal spacing between columns
            GridItem(.flexible(), spacing: 40),
    ]
    
    var body: some View {
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
                                                        HStack{
                                                            Text("Total Words") //place holder score for now
                                                                .bold()
                                                                .font(.system(size:14))
                                                            MoneyView()
                                                                .offset(x: -35)
                                                                .scaleEffect(0.5)
                                                            Text("\(userData.totalPts)")
                                                                .bold()
                                                                .font(.system(size: 28))
                                                                .foregroundStyle(mainColor)
                                                                .offset(x: -30)
                                                        }
                                                        .frame(height: 20)
//
//                                                        + Text("    \(userData.totalPts) 💰")
//                                                            .bold()
//                                                            .foregroundColor(mainColor)
//                                                            .font(.system(size: 23))
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
                                    .matchedTransitionSource(id: level.level, in: animationNamespace) // Transition 2
                                    .onTapGesture {
                                        if level.unlocked{
                                            GlobalAudioSettings.shared.playSoundEffect(for: "BackBubble", audioPlayer: &audioPlayer)
                                            navPath.append(DestinationStruct.Destination.levelDestination(level: level, animation: animationNamespace, comingFromFastTravel: false))
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
            .navigationBarBackButtonHidden(true)
            .task{
                withAnimation(.spring(response: 0.3, dampingFraction: 0.6)){
                    userData.updatePtsAndRank(levels: levels)
                }
            }
    }
    
}

#Preview {
    @Previewable @State var navPath = NavigationPath()
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Level.self, configurations: config)
        let userData = UserData()
        container.mainContext.insert(Level(level: 0, foundWords: [[String]](), foundQuartiles: [String](), completed: false, rank: "Novice", score: 0, unlocked: true))
        container.mainContext.insert(Level(level: 1, foundWords: [[String]](), foundQuartiles: [String](), completed: false, rank: "Novice", score: 0, unlocked: false))
        container.mainContext.insert(Level(level: 2, foundWords: [[String]](), foundQuartiles: [String](), completed: false, rank: "Novice", score: 0, unlocked: false))
        container.mainContext.insert(Level(level: 3, foundWords: [[String]](), foundQuartiles: [String](), completed: false, rank: "Novice", score: 0, unlocked: false))
        container.mainContext.insert(Level(level: 4, foundWords: [[String]](), foundQuartiles: [String](), completed: false, rank: "Novice", score: 0, unlocked: false))
        container.mainContext.insert(Level(level: 5, foundWords: [[String]](), foundQuartiles: [String](), completed: false, rank: "Novice", score: 0, unlocked: false))
        container.mainContext.insert(Level(level: 6, foundWords: [[String]](), foundQuartiles: [String](), completed: false, rank: "Novice", score: 0, unlocked: false, redeemed: false))
        container.mainContext.insert(Level(level: 7, foundWords: [[String]](), foundQuartiles: [String](), completed: false, rank: "Novice", score: 0, unlocked: false, redeemed: false))
        return LevelView(navPath: $navPath)
            .modelContainer(container)
            .environmentObject(userData)
    } catch {
        return Text("Failed to create container: \(error.localizedDescription)")
    }
}
