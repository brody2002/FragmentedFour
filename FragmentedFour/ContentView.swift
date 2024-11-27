//
//  ContentView.swift
//  FragmentedFour
//
//  Created by Brody on 11/26/24.
//

//Video Progress -> 1:43:55

import SwiftUI

struct ContentView: View {
    
    let levels: [[String]] = Bundle.main.decode("levels.txt")
    
    @State private var tiles = [String]()
    @State private var selectedTiles = [String]()
    @State private var orderedTiles = [String]()
    
    @State private var foundWords = [[String]]()
    @State private var foundQuartiles = [String]()
    @State private var isGroupingQuartiles = true
    
    @State private var score = 0
    @State private var currentLevel = 0
    
    @State private var showWinScreenView = false
    
    @State private var showSideBarView = false
    @State private var sideBarDragOffset = CGSize.zero
    @State var shouldRestartLevel = false
    
    let gridLayout = Array(repeating:  GridItem.init(.flexible(minimum: 50, maximum: 100)), count: 4)
    
    var dictionary: Set<String> = {
        guard let url = Bundle.main.url(forResource: "dictionary", withExtension: "txt") else { fatalError("Couldn't locate dictionary.txt")}
        
        guard let contents = try? String(contentsOf: url, encoding: .utf8) else { fatalError("Couldn'tn load dictionary.txt")}
        
        return Set(contents.components(separatedBy: .newlines))
        
    }()
    
    var canSubmit: Bool {
        let selectedWord = selectedTiles.joined()
        
        guard selectedTiles.isEmpty == false else { return false }
        guard dictionary.contains(selectedWord) else { return false}
        
        return !foundWords.contains(selectedTiles)
    }
    
    
    var body: some View {
        ZStack{
            // Side Bar UI
            ZStack{
                if showSideBarView{
                    Color.black.opacity(0.25).ignoresSafeArea()
                    GeometryReader { proxy in
                        HStack{
                            SideBarView(shouldRestartLevel: $shouldRestartLevel)
                                .offset(x: sideBarDragOffset.width) // Apply the drag offset here
                                .gesture(
                                    DragGesture()
                                        .onChanged { value in
                                            if value.translation.width < 0 {
                                                sideBarDragOffset = CGSize(width: max(value.translation.width, -UIScreen.main.bounds.width), height: 0)
                                            }
                                        }
                                        .onEnded { gesture in
                                            if gesture.translation.width < -60 {
                                                withAnimation(.easeOut(duration: 0.2)) {
                                                    sideBarDragOffset.width = -UIScreen.main.bounds.width
                                                    showSideBarView.toggle()
                                                    print("showSideBarView -> \(showSideBarView)")
                                                    
                                                }
                                            } else {
                                                withAnimation {
                                                    sideBarDragOffset = .zero
                                                }
                                            }
                                        }
                                )
                                
                            Spacer()
                        }
                    }
                    .offset(x: showSideBarView ? 0 : -UIScreen.main.bounds.width)
                    .transition(.move(edge: .leading))
                }
            }
            .zIndex(3)
            
            // Main App UI
            VStack{
                // TopBar UI
                HStack(alignment: .bottom) {
                    ZStack(alignment: .leading) {
                        Button(
                            action: {
                                withAnimation(.easeOut(duration: 0.2)) {
                                            if showSideBarView {
                                                showSideBarView = false
                                            } else {
                                                sideBarDragOffset = .zero // Reset offset
                                                showSideBarView = true
                                            }
                                        }
                            },
                            label: {
                                Image(systemName: "equal")
                                    .resizable()
                                    .frame(width: 40, height: 20)
                                    .foregroundStyle(.white)
                            }
                        )
                        .offset(y: -70)
                        
                        RankView(score: score)
                    }
                    .frame(maxWidth: 100)
                    Spacer()
                    ScoreView(score: score)
                        .frame(maxWidth: .infinity)
                    Spacer()
                    
                    ZStack(alignment: .leading){
                        
                        Text("Level  \(currentLevel + 1)")
                            .multilineTextAlignment(.leading)
                            .foregroundStyle(.white)
                            .font(.title.bold())
                            .offset(y: -70)
                        
                        QuartilesFoundView(quartiles: foundQuartiles.count / 4)
                    }
                    .frame(maxWidth: 100)
                    
                }
                .padding()
                .padding(.bottom, 60)
                .foregroundStyle(.white)
                .background(.blue)
                
                
                ZStack(alignment: .top) {
                    // WinScreen UI
                    if showWinScreenView {
                        VStack(alignment: .center){
                            Spacer()
                                .frame(maxHeight: 120)
                            ScoreShieldView(score: score, rank: Rank.name(for: score))
                            Spacer()
                                .frame(height: 20)
                            VStack(spacing: 5){
                                Text("Congratulations")
                                    .font(.title.bold())
                                Text("You reached the highest rank")
                                    .font(.body.bold())
                                    .foregroundColor(.black.opacity(0.5))
                                Text("Proceed to the next level?")
                                    .font(.body.bold())
                                    .foregroundColor(.black.opacity(0.5))
                                
                            }
                            Spacer()
                                .frame(height: 20)
                            Button(action: {
                                setupNextLevel()
                            }, label:{
                                Text("Next Level")
                                    .font(.title2.bold())
                                    .foregroundStyle(.white)
                                    .frame(minWidth: 180, maxWidth: 240, maxHeight: 50)
                                    .background(.blue)
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                                    .padding(.horizontal)
                            })
                            Spacer()
                                .frame(minHeight: 80)
                        }
                        
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .frame(maxWidth: .infinity, minHeight: 400, maxHeight: 400)
                        .background(AppColors.body)
                        .cornerRadius(10)
                        .shadow(color: Color(.black.opacity(0.25)), radius: 10)
                        .padding(.horizontal)
                        .zIndex(2)
                        .padding(.top ,100)
                    }
                    
                    WordsFoundView(words: foundWords)
                        .zIndex(1)
                        .opacity(showWinScreenView ? 0 : 1)
                    
                    VStack{
                        
                        //hidden placeholder
                        WordsFoundView(words: foundWords)
                            .hidden()
                        
                        Spacer()
                        
                        HStack{
                            if selectedTiles.isEmpty{
                                // hidden tile so that the UI doesnt move...
                                SelectedTileView(text: "aa")
                                    .hidden()
                            } else {
                                ForEach(selectedTiles, id:
                                            \.self) { tile in
                                    Button {
                                        deselect(tile)
                                    } label : {
                                        SelectedTileView(text: tile)
                                    }
                                }
                                Button("Clear", systemImage: "xmark.circle", action: clearSelected)
                                    .labelStyle(.iconOnly)
                                    .symbolVariant(.fill)
                            }
                        }
                        Spacer()
                        
                        // grid groes vertically as more items are added
                        LazyVGrid(columns: gridLayout) {
                            ForEach(orderedTiles, id: \.self){ tile in
                                Button {
                                    select(tile)
                                } label: {
                                    TileView(
                                        text: tile,
                                        isSelected: selectedTiles.contains(tile),
                                        isHighlighted: isGroupingQuartiles && foundQuartiles.contains(tile)
                                    )
                                    .transition(.identity)
                                }
                                .buttonStyle(.plain)
                                
                            }
                        }
                        .opacity(showWinScreenView ? 0 : 1)
                        
                        Spacer()
                        
                        HStack{
                            Button(action: shuffletiles){
                                Label("Shuffles", systemImage: "shuffle")
                                    .padding(5)
                                    .font(.headline)
                            }
                            .buttonStyle(.bordered)
                            .buttonBorderShape(.circle)
                            
                            Spacer()
                            
                            Button(action: submit){
                                Label("Submit", systemImage: "checkmark")
                                    .padding(10)
                                    .font(.title)
                            }
                            .buttonStyle(.borderedProminent)
                            .buttonBorderShape(.circle)
                            .disabled(canSubmit == false)
                            
                            Spacer()
                            
                            Button(action: toggleGrouping){
                                Label("Group", systemImage: "list.star")
                                    .padding(5)
                                    .font(.title)
                            }
                            .buttonStyle(.bordered)
                            .buttonBorderShape(.circle)
                            .tint(isGroupingQuartiles ? .blue : nil)
                        }
                        .padding(.bottom, -40)
                        .opacity(showWinScreenView ? 0 : 1)
                    }
                }
                .padding(.horizontal)
                .offset(y: -40)
                
            }
            .frame(maxHeight: .infinity)
            .background(.quinary)
            .fontDesign(.rounded)
            .font(.title2.bold())
            .preferredColorScheme(.light)
            .task{
                loadLevel()
            }
            .onChange(of: shouldRestartLevel){
                restartLevel()
            }
        }
        
        
    }
    
    
    func loadLevel(){
        tiles = levels[currentLevel].shuffled()
        orderedTiles = tiles
    }
    func clearSelected(){
        selectedTiles.removeAll()
    }
    func select(_ tile: String){
        guard selectedTiles.count < 4 else { return }
        guard selectedTiles.contains(tile) == false else { return }
        
        selectedTiles.append(tile)
    }
    func deselect(_ tile: String){
        selectedTiles.removeAll { $0 == tile }
    }
    func shuffletiles() {
        withAnimation{
            tiles.shuffle()
            orderedTiles = tiles
            groupQuartiles()
        }
    }
    
    func submit() {
        withAnimation(.spring(response: 0.4, dampingFraction: 0.6)){
            foundWords.append(selectedTiles)
            score += selectedTiles.score
            
            if selectedTiles.count == 4 {
                foundQuartiles.append(contentsOf: selectedTiles)
            }
            
            selectedTiles.removeAll()
            groupQuartiles()
            
            if score >= 100 {
                showWinScreenView.toggle()
                
            }
        }
    }
    
    func toggleGrouping(){
        withAnimation{
            isGroupingQuartiles = true
            
            if isGroupingQuartiles{
                groupQuartiles()
            } else {
                orderedTiles = tiles
            }
        }
    }
    
    func groupQuartiles(){
        guard isGroupingQuartiles else { return }
        
        for quartile in foundQuartiles {
            orderedTiles.removeAll(where: quartile.contains)
            orderedTiles.append(quartile)
        }
    }
    
    func setupNextLevel() {
        currentLevel += 1
        clearData()
    }
    func restartLevel(){
        clearData()
        // moves side bar out of view
        withAnimation(.easeOut(duration: 0.2)){
            sideBarDragOffset.width = -UIScreen.main.bounds.width
            showSideBarView = false
        }
        
        
        
    }
    func clearData(){
        withAnimation(.spring(response: 0.4, dampingFraction: 0.6)){
            loadLevel()
            showWinScreenView = false
            foundQuartiles.removeAll()
            foundWords.removeAll()
            score = 0
        }
    }
    
}

#Preview {
    ContentView()
}
