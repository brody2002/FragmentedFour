//
//  LevelInfo.swift
//  FragmentedFour
//
//  Created by Brody on 11/29/24.
//

import Foundation
import SwiftData

@Model
class Level: Identifiable, ObservableObject{
    var level: Int
    var foundWords: [[String]]
    var foundQuartiles: [String] // List of the individual quartiles that make up the whole word. So 1 word equal foundQuartiles.count -> 4
    var completed: Bool
    var rank: String
    var score: Int
    var unlocked: Bool
    
    init(level: Int, foundWords: [[String]], foundQuartiles: [String], completed: Bool, rank: String, score: Int, unlocked: Bool) {
        self.level = level
        self.foundWords = foundWords
        self.foundQuartiles = foundQuartiles
        self.completed = completed
        self.rank = rank
        self.score = score
        self.unlocked = unlocked
    }
}
//TODO: Add functions that save to coreData
