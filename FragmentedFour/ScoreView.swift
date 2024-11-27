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
        VStack(spacing: 0){
            Text(String(score))
                .font(.system(size: 56))
            Text(Rank.name(for: score))
                .font(.title3.bold())
                .minimumScaleFactor(0.5)
        }
    }
}

#Preview {
    ScoreView(score: 16)
}
