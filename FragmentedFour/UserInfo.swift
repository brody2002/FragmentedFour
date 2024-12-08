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
    
    init() {
        self.totalPts = 0
        self.avgRank = "Novice"
        self.completedLevels = 0
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
        print("Levels coming in: \(levels.count)" )
        for level in levels{
            
            if level.completed {
                
                latestLevel += 1
            }
            if level.completed == false && level.unlocked == true{
                //print("returning Level")
                return level
            }
            
        }
        //print("returning LatestLevel")
        return levels[latestLevel]
    }
}
