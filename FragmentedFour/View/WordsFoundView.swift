//
//  WordsFoundView.swift
//  FragmentedFour
//
//  Created by Brody on 11/26/24.
//

import SwiftUI

struct WordsFoundView: View {
    @State private var isExpanded: Bool = false
    
    let wordLayout = Array(repeating: GridItem(.flexible(minimum: 50, maximum: 500)), count: 2)
    
    
    var words: [[String]]
    @State var mainColor: Color
    
    
    var body: some View {
        VStack{
            HStack{
                if isExpanded{
                    Text("^[\(words.count) words](inflect:true)")
                } else {
                    VStack(alignment: .leading) {
                        Text("WORDS FOUND")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .foregroundStyle(.secondary)
                            .font(.caption.bold())
                        
                        Group{
                            if words.isEmpty{
                                Text(" ")
                                
                            } else {
                                let wordsString = words.map { $0.joined() }.joined(separator: ", ")
                                
                                Text(wordsString)
                                    .lineLimit(1)
                            }
                        }
                        .font(.body)
                    }
                }
                Spacer()
                
                Button(action: toggleExpanded){
                    Label("Expand", systemImage: "chevron.down")
                        .rotationEffect(.degrees(isExpanded ? 180 : 0))
                        .padding(5)
                    
                }
                .tint(mainColor)
                .buttonStyle(.bordered)
                .buttonBorderShape(.circle)
            }
            .opacity(words.isEmpty ? 0 : 1)
            .overlay(
                words.isEmpty
                ? Text("Words you find appear here")
                    .foregroundStyle(.tertiary)
                    .font(.body.bold())
                : nil
            )
            
            if isExpanded {
                ScrollView{
                    LazyVGrid(columns: wordLayout) {
                        ForEach(0..<words.count, id: \.self) { index in
                            let word = words[index]
                            VStack{
                                HStack{
                                    Text(word.joined())
                                    
                                    Spacer()
                                    
                                    if word.score == 8 {
                                        Text(String(word.score))
                                            .padding(1)
                                            .padding(.horizontal)
                                            .foregroundStyle(.white)
                                            .background(AppColors.coreBlue)
                                            .cornerRadius(10)
                                        
                                    } else {
                                        Text(String(word.score))
                                            .padding(.horizontal)
                                            .foregroundStyle(AppColors.coreBlue)
                                    }
                                    
                                    
                                }
                                if hasRowBelow(index: index){
                                    Divider()
                                } else {
                                    Divider().hidden()
                                }
                            }
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .font(.body)
                }
                .frame(maxHeight: 300)
                
            }
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(.white)
        .clipShape(.rect).cornerRadius(10)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(.quaternary)
                .offset(y: 4)
        )
    }
    
    func toggleExpanded() {
        withAnimation(.spring(response: 0.4, dampingFraction: 0.6)){
            isExpanded.toggle()
        }
        
    }
    
    func hasRowBelow(index: Int) -> Bool {
        index + wordLayout.count < words.count
        
    }
}

#Preview {
    WordsFoundView(words: [["hel", "lo"],["wor","ld"]], mainColor: AppColors.coreBlue)
}
