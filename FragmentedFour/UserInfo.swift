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
//        print("average rank \(Rank.name(for: totalPts / max(self.completedLevels, 1)))")
        self.avgRank = Rank.name(for: totalPts / max(self.completedLevels, 1))
    }
}
