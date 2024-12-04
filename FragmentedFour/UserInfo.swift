//
//  UserInfo.swift
//  FragmentedFour
//
//  Created by Brody on 12/3/24.
//


import Foundation

@Observable
class UserData: ObservableObject {
    var totalPts: Int
    var avgRank: String
    var unlockedLevels: Int
    
    init() {
        self.totalPts = 0
        self.avgRank = "Novice"
        self.unlockedLevels = 1
    }
    
    func updatePtsAndRank(levels: [Level]) {
        //Restart values
        self.totalPts = 0
        self.unlockedLevels = 1
        for level in levels {
            if level.unlocked {
                self.totalPts += level.score
                self.unlockedLevels += 1
            }
        }
        unlockedLevels -= 1 
        self.avgRank = Rank.name(for: totalPts / max(self.unlockedLevels, 1))
    }
}
