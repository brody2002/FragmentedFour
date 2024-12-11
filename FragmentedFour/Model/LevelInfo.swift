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
class Level: Identifiable, ObservableObject, Hashable{
    var level: Int
    var foundWords: [[String]]
    var foundQuartiles: [String] // List of the individual quartiles that make up the whole word. So 1 word equal foundQuartiles.count -> 4
    // Can only be the intended Quartiles
    var completed: Bool
    var rank: String
    var score: Int
    var unlocked: Bool
    var levelThreshhold: Int
    var foundAllWords: Bool
    var redeemed: Bool
    
    init(level: Int, foundWords: [[String]], foundQuartiles: [String], completed: Bool, rank: String, score: Int, unlocked: Bool, levelThreshhold: Int = 15, foundAllWords: Bool = false, redeemed: Bool = true) {
        self.level = level
        self.foundWords = foundWords
        self.foundQuartiles = foundQuartiles
        self.completed = completed
        self.rank = rank
        self.score = score
        self.unlocked = unlocked
        self.levelThreshhold = levelThreshhold
        self.foundAllWords = foundAllWords
        self.redeemed = redeemed
    }
}
//TODO: Add functions that save to coreData
