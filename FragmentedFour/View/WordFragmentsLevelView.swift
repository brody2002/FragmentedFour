//
//  WordFragmentsLevelView.swift
//  FragmentedFour
//
//  Created by Brody on 12/2/24.
//

import SwiftUI

struct WordFragmentsLevelView: View {
    var text: String
    var body: some View {
        Text(text)
            .font(.system(size: 8))
            .bold()
            .frame(maxWidth: .infinity, minHeight: 10, maxHeight: 10)
            .background(Color.white)
            .clipShape(.rect(cornerRadius: 10))
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(.gray.opacity(0.25))
                    .offset(y: 4)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .strokeBorder(.clear, lineWidth: 2)
            )
    }
}

#Preview {
    WordFragmentsLevelView(text: "abc")
}
