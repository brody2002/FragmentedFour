//
//  ScoreShieldView.swift
//  FragmentedFour
//
//  Created by Brody on 11/27/24.
//

import SwiftUI

struct ScoreShieldView: View {
    
    var score: Int
    var rank: String
    
    var body: some View {
        ZStack{
            Image(systemName: "shield.fill")
                .resizable()
                .frame(width: 120, height: 130)
                .foregroundStyle(.white)
            
            Image(systemName: "shield")
                .resizable()
                .frame(width: 105, height: 115)
                .foregroundStyle(AppColors.darkBlue)
            
            Image(systemName: "shield.fill")
                .resizable()
                .frame(width: 90, height: 100)
                .foregroundStyle(.blue)
            
            Text(String(score))
                .font(.title.bold())
                .foregroundStyle(.white)
                .offset(y: -20)
            
            Text(String(rank))
                .font(.system(size: 16).bold())
                .foregroundStyle(.white)
                .offset(y: 8)
        }
        
    }
}

#Preview {
    ZStack{
        Color.gray.ignoresSafeArea()
        ScoreShieldView(score: 77, rank: "Wordsmith")
    }
    
}
