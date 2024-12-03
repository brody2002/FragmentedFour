//
//  UserInfo.swift
//  FragmentedFour
//
//  Created by Brody on 12/3/24.
//

import Foundation
import SwiftData

@Model
class UserData: Identifiable{
    var id: String
    var totalPts: Int
    var avgRank: String
    
    init(){
        self.id = "UserData"
        self.totalPts = 0
        self.avgRank = "Novice"
    }
    
    func updatePtsAndRank(levels: [Level]){
        let levelsUnlocked = levels.count
        for level in levels{
            if level.completed{
                self.totalPts += level.score
            }
        }
        self.avgRank = Rank.name(for: totalPts / levelsUnlocked)
    }
}
