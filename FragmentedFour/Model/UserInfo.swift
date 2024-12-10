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
    var completedLevels: Int
    var unlockedLevels: Int
    
    init(totalPts: Int = 0, avgRank: String = "Novice", completedLevels: Int = 0, unlockedLevels: Int = 5) {
        self.totalPts = totalPts
        self.avgRank = avgRank
        self.completedLevels = completedLevels
        self.unlockedLevels = unlockedLevels
    }
    
    func updatePtsAndRank(levels: [Level]) {
        //Restart values
        self.totalPts = 0
        self.completedLevels = 0
        for level in levels {
            if level.completed {
                self.totalPts += level.score
                self.completedLevels += 1
            }
        }
        self.avgRank = Rank.name(for: totalPts / max(self.completedLevels, 1))
    }
    
    func findCurrentLevel(levels: [Level]) -> Level {
        var latestLevel = 0 // Used for if user has completed everything they have access to
        for level in levels{
            
            if level.completed {
                
                latestLevel += 1
            }
            if level.completed == false && level.unlocked == true{
                print("returning Level")
                return level
            }
            
        }
        print("returning LatestLevel")
        return levels[latestLevel - 1]
    }
}
