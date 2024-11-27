//
//  RankView.swift
//  FragmentedFour
//
//  Created by Brody on 11/26/24.
//

import SwiftUI

struct RankView: View {
    var score: Int
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Next Rank")
                .font(.body.bold())
            
            MyProgressView(backgroundColor: .blue.mix(with: .black, by: 0.25), foregroundColor: .white, progress: Rank.progressTorwardsNextRank(for: score), total: 1)
                .frame(height: 16)
        }
        
    }
}

#Preview {
    RankView(score: 44)
}
