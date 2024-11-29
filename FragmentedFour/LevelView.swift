//
//  LevelView.swift
//  FragmentedFour
//
//  Created by Brody on 11/29/24.
//


import SwiftUI

//TODO: Incoorporate way to show that level has been completed?


struct LevelView: View {
    // Define the levels as a range for simplicity
    let levels = Array(1...10) // Represents 10 levels
    
    // Define the grid layout
    let columns = [
            GridItem(.flexible(), spacing: 20), // Add horizontal spacing between columns
            GridItem(.flexible(), spacing: 20),
            GridItem(.flexible(), spacing: 20)
    ]
    
    var body: some View {
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
                        // Loop through levels to create items
                        ForEach(levels, id: \.self) { level in
                            LevelTileView(level: level, completed: true) // Pass the level number here
                                .onTapGesture {
                                    // Navigate to the code
                                }
                        }
                    }
                    .padding(.leading, 40)
                    .padding(.trailing, 40)// Add padding around the grid
                }
            }
            
            
           
        }
        
    }
}


#Preview {
    LevelView()
}

