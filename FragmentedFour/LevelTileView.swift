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
    
    var body: some View {
        if completed{
            ZStack{
                Image(systemName: "trophy.fill")
                    .resizable()
                    .frame(width: 40, height: 40)
                    .foregroundStyle(.white.opacity(0.5))
                    .padding()
                Text(String(level))
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
            Text(String(level))
                .frame(maxWidth: .infinity, minHeight: 44, maxHeight: 64)
                .background(Color.white)
                .clipShape(.rect(cornerRadius: 10))
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(.gray.opacity(0.25))
                        .offset(y: 4)
                )
        }
        
            
    }
}

#Preview {
    ZStack{
        Color.red.ignoresSafeArea()
        LevelTileView(level: 1, completed: true)
    }
    
}
