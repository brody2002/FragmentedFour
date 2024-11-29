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
                                    
                                    
                            }
                        }
                        .padding(.leading, 40)
                        .padding(.trailing, 40)// Add padding around the grid
                    }
                }
                
                
               
            }
        }
        .task{
            print(levels)
            print(levels.count)
            
        }
        
        
    }
        
}


#Preview {
    
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Level.self, configurations: config)
        container.mainContext.insert(Level(level: 1, words: ["hello","world"], completed: false, rank: "Novice", score: 0))
        container.mainContext.insert(Level(level: 2, words: ["hello","world2"], completed: true, rank: "Master", score: 101))
        return LevelView()
            .modelContainer(container)
    } catch {
        return Text("Failed to create container: \(error.localizedDescription)")
    }
}

