//
//  LevelTileView.swift
//  FragmentedFour
//
//  Created by Brody on 11/29/24.
//

import SwiftUI


struct LevelTileView: View {
    var level: Int
    var completed: Bool
    var unlocked: Bool
    var score: Int
    var redeemed: Bool
    
    var buttonWidth: CGFloat = 120
    var buttonHeight: CGFloat = 80
    
    
    let levels: [[String]] = Bundle.main.decode("levels.txt")
    let gridLayout = Array(repeating:  GridItem.init(.flexible(minimum: 20, maximum: 20)), count: 4)
    @State private var tiles = [String]()
    
    
    var body: some View {
        ZStack{
            
            LazyVGrid(columns: gridLayout, spacing: 4) {
                ForEach(tiles, id: \.self){ tile in

                    WordFragmentsLevelView(text: tile)
                        
                    
                    
                }
            }
            .opacity(!unlocked || completed ? 0.0: 0.4)
            .frame(width: buttonWidth, height: buttonHeight)
            
            
            
            if completed && unlocked{
            
                ZStack{
                    
                    Image(systemName: "trophy.fill")
                        .resizable()
                        .frame(width: 40, height: 40)
                        .foregroundStyle(score >= 100 ?  AppColors.trophyYellow : .white.opacity(0.7))
                        .offset(y: 5)
                        .padding()
                    Text(String(level + 1))
                        .frame(width: 35, height: 30)
                        .clipShape(.rect(cornerRadius: 10))
                        .foregroundStyle(.white)
                        .font(.title.bold())
                        .cornerRadius(10)
                        
                    
                        
                    Text(Rank.name(for: score))
                        .foregroundStyle(.white)
                        .font(.system(size: 10))
                        .bold()
                        .offset(y: -27)
                    
                        
                }
                
                
                
                
                    
            } else if !completed && unlocked{
                ZStack{
                    
                    Text(String(level + 1))
                        .frame(maxWidth: .infinity, minHeight: 44, maxHeight: 64)
                        .clipShape(.rect(cornerRadius: 10))
                        .foregroundStyle(.white)
                        .font(.title.bold())
                    
                        
                }
                
                    
            }
            else if !completed && !unlocked && !redeemed{
                
            }
            else{
                // Locked
                ZStack{
                    Image(systemName: "lock.fill")
                        .resizable()
                        .frame(width: 40, height: 40)
                        .foregroundStyle(.white.opacity(0.5))
                        .padding()
                    
                    
                    Text(String(level + 1))
                        .frame(maxWidth: .infinity, minHeight: 44, maxHeight: 64)
                        .clipShape(.rect(cornerRadius: 10))
                        .foregroundStyle(.white)
                        .font(.title.bold())
                    
                        
                }
                
            }
        }
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(completed && score >= 100 ? AppColors.masterRed : redeemed ? (unlocked ? AppColors.coreBlue : .gray) : .black)
        )
        .frame(width: buttonWidth, height: buttonHeight)
        .task {
            tiles = levels[level].shuffled()
        }
        
        
        
            
    }
        
}

#Preview {
    ZStack{
        Color.red.ignoresSafeArea()
        LevelTileView(level: 1, completed: true, unlocked: true, score: 33, redeemed: false)
    }
    
}
