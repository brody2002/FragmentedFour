//
//  LevelInfo.swift
//  FragmentedFour
//
//  Created by Brody on 11/29/24.
//

import Foundation
import SwiftData
import SwiftUI

@Model
class Level: Identifiable, ObservableObject{
    var id: UUID
    var level: Int
    var foundWords: [[String]]
    var foundQuartiles: [String] // List of the individual quartiles that make up the whole word. So 1 word equal foundQuartiles.count -> 4
    var completed: Bool
    var rank: String
    var score: Int
    var unlocked: Bool
    var levelThreshhold: Int
    var foundAllWords: Bool
    
    init(level: Int, foundWords: [[String]], foundQuartiles: [String], completed: Bool, rank: String, score: Int, unlocked: Bool, levelThreshhold: Int = 15, foundAllWords: Bool = false, mainColor: Color = AppColors.coreBlue) {
        self.id = UUID()
        self.level = level
        self.foundWords = foundWords
        self.foundQuartiles = foundQuartiles
        self.completed = completed
        self.rank = rank
        self.score = score
        self.unlocked = unlocked
        self.levelThreshhold = levelThreshhold
        self.foundAllWords = foundAllWords
    }
}
//TODO: Add functions that save to coreData
