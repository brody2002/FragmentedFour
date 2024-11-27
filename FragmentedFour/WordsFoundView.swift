//
//  WordsFoundView.swift
//  FragmentedFour
//
//  Created by Brody on 11/26/24.
//

import SwiftUI

struct WordsFoundView: View {
    
    var words: [[String]]
    
    
    var body: some View {
        let wordsString = words.map { $0.joined() }.joined(separator: ", ")
        Text(wordsString)
    }
}

#Preview {
    WordsFoundView(words: [["hel", "lo"],["wor","ld"]])
}
