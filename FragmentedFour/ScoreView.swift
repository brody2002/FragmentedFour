//
//  ScoreView.swift
//  FragmentedFour
//
//  Created by Brody on 11/26/24.
//

import SwiftUI

struct ScoreView: View {
    var score: Int
    var body: some View {
        ZStack{
            VStack(spacing: 0){
                Text(String(score))
                    .font(.system(size: 56))
                    .foregroundStyle(score >= 100 ? AppColors.trophyYellow : .white)
                Text(Rank.name(for: score))
                    .font(.title3.bold())
                    .minimumScaleFactor(0.5)
                    .foregroundStyle(score >= 100 ? AppColors.trophyYellow : .white)
            }
            Image(systemName: "crown.fill")
                .resizable()
                .frame(width: 30, height: 24)
                .foregroundStyle(AppColors.trophyYellow)
                .opacity(score >= 100 ? 1.0 : 0.0)
                .offset(y: 63)
            
        }
        
    }
}

#Preview {
    ZStack{
        Color.orange
        ScoreView(score: 102)
    }
    
}
