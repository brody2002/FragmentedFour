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
                .foregroundStyle(score >= 100 ? .gray.opacity(0.6) : .white)
            
            Image(systemName: "shield")
                .resizable()
                .frame(width: 105, height: 115)
                .foregroundStyle(score >= 100 ? AppColors.masterRedDark : AppColors.darkBlue)
            
            Image(systemName: "shield.fill")
                .resizable()
                .frame(width: 90, height: 100)
                .foregroundStyle(score >= 100 ? AppColors.masterRed : AppColors.coreBlue)
            
            Text(String(score))
                .font(.title.bold())
                .foregroundStyle(score >= 100 ? AppColors.trophyYellow : .white)
                .offset(y: -20)
            
            Text(String(rank))
                .font(.system(size: 16).bold())
                .foregroundStyle(score >= 100 ? AppColors.trophyYellow : .white)
                .offset(y: 8)

            
            Image(systemName: "crown.fill")
                .resizable()
                .frame(width: 20, height: 16)
                .foregroundStyle(AppColors.trophyYellow)
                .offset(y: 30)
                .opacity(score >= 100 ? 1.0 : 0.0)
        }
        
    }
}

#Preview {
    ZStack{
        Color.black.ignoresSafeArea()
        ScoreShieldView(score: 101, rank: "Wordsmith")
    }
    
}
