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
    var words: [String]
    var completed: Bool
    var rank: String
    var score: Int
    
    init(level: Int, words: [String], completed: Bool, rank: String, score: Int) {
        self.level = level
        self.words = words
        self.completed = completed
        self.rank = rank
        self.score = score
    }
}
