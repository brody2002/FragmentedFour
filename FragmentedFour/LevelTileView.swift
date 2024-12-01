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
    
    var body: some View {
        if completed && unlocked{
        
            ZStack{
                Image(systemName: "trophy.fill")
                    .resizable()
                    .frame(width: 40, height: 40)
                    .foregroundStyle(score >= 100 ?  .yellow.opacity(0.9): .white.opacity(0.5))
                    .padding()
                Text(String(level + 1))
                    .frame(maxWidth: .infinity, minHeight: 44, maxHeight: 64)
                    .clipShape(.rect(cornerRadius: 10))
                    .foregroundStyle(.white)
                    .font(.title.bold())
                Text(Rank.name(for: score))
                    .foregroundStyle(.white)
                    .font(.system(size: 10))
                    .bold()
                    .offset(y: -27)
                
                    
            }
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(score >= 100 ? .red : .blue)
            )
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(.gray.opacity(0.5))
                    .offset(y: 4)
            )
            
            
            
                
        } else if !completed && unlocked{
            ZStack{
                Text(String(level + 1))
                    .frame(maxWidth: .infinity, minHeight: 44, maxHeight: 64)
                    .clipShape(.rect(cornerRadius: 10))
                    .foregroundStyle(.white)
                    .font(.title.bold())
                
                    
            }
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(.blue)
            )
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(.gray.opacity(0.5))
                    .offset(y: 4)
            )
                
        } else{
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
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(.gray)
            )
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(.gray.opacity(0.5))
                    .offset(y: 4)
            )
        }
        
            
    }
}

#Preview {
    ZStack{
        Color.red.ignoresSafeArea()
        LevelTileView(level: 1, completed: true, unlocked: true, score: 100)
    }
    
}
