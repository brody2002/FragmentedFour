//
//  Rank.swift
//  FragmentedFour
//
//  Created by Brody on 11/26/24.
//

import Foundation

struct Rank{
    var name: String
    var minimumScore: Int
    
    private init(name: String, minimumScore: Int){
        self.name = name
        self.minimumScore = minimumScore
    }
    
    static let allRanks = [
        Rank(name: "Novice", minimumScore: 0),
        Rank(name: "Explorer", minimumScore: 5),
        Rank(name: "Architect", minimumScore: 15),
        Rank(name: "Craftsman", minimumScore: 30),
        Rank(name: "Virtuoso", minimumScore: 50),
        Rank(name: "Master", minimumScore: 100)
    ]
    
    static func name(for score: Int) -> String {
        // iterates from the last value of the array ex: 100
        // Then keeps checking until condition is satisfied ex: { $0.minimumScore <= score }
        let currentRank = allRanks.last { $0.minimumScore <= score }
        return currentRank?.name ?? "Unknown"
    }
    
    static func progressTorwardsNextRank(for score: Int) -> Double{
    
        var previousRankScore = 0
        for rank in allRanks {
            if score < rank.minimumScore {
                let gapFromPreviousRank = Double(score - previousRankScore)
                let gapToNextTank = Double(rank.minimumScore - previousRankScore)
                return gapFromPreviousRank / gapToNextTank
            } else {
                previousRankScore = rank.minimumScore
            }
        }
        
        return 1
    }
}

