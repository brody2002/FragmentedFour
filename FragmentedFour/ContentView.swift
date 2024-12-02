//
//  ContentView.swift
//  FragmentedFour
//
//  Created by Brody on 11/26/24.
//

//Video Progress -> 1:43:55

import SwiftData
import SwiftUI

struct ContentView: View {
    @Environment(\.modelContext) var modelContext

    
    let levels: [[String]] = Bundle.main.decode("levels.txt")
    
    @State private var tiles = [String]()
    @State private var selectedTiles = [String]()
    @State private var orderedTiles = [String]()
    
    @State private var turnRed: Bool = false
    @State private var turnGreen: Bool = false
    @State private var showX: Bool = true
    
    
    @State private var fetchedLevel: Level? = nil
    @State var scoreToBeat: Int?
    
    @State private var isGroupingQuartiles = true
    
    // Pass through vals from LevelView
    @State var score: Int
    @State var currentLevel: Int
    @State var foundWords: [[String]]
    @State var foundQuartiles: [String]
    
    @State private var showWinScreenView = false
    
    @State private var showSideBarView = false
    @State private var sideBarDragOffset = CGSize.zero
    @State var shouldRestartLevel = false
    
    @State private var foundAllQuartiles = false
    
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
                                Text(score >= 100 ? "You reached the highest rank!" : "You scored enough points!")
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
                            
                            Button(action: {
                                showWinScreenView.toggle()
                            }, label:{
                                Text("Continue Playing")
                                    .font(.title3.bold())
                                    .foregroundStyle(.white)
                                    .frame(minWidth: 180, maxWidth: 240, maxHeight: 50)
                                    .background(.blue)
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                                    .padding(.horizontal)
                            })
                            Spacer()
                                .frame(minHeight: 80)
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
                                SelectedTileView(text: "aa", turnRed: $turnRed, turnGreen: $turnGreen)
                                    .hidden()
                            } else {
                                ForEach(selectedTiles, id:
                                            \.self) { tile in
                                    Button {
                                        deselect(tile)
                                    } label : {
                                        SelectedTileView(text: tile, turnRed: $turnRed, turnGreen: $turnGreen)
                                            
                                        
                                    }
                                }
                                
                                Button("Clear", systemImage: "xmark.circle", action: clearSelected)
                                    .opacity(showX ? 1.0 : 0.0)
                                    .animation(nil, value: showX)
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
                                //Custom Style preventing button from going gray on disable
                                .buttonStyle(NoGrayOutButtonStyle())
        
                                .disabled(turnRed)
                                
                                
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
                            .disabled(selectedTiles.isEmpty)
                            
                            
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
                fetchedLevel = fetchLevel(levelNumber: currentLevel, context: modelContext)!
               
                loadLevel()
                if isGroupingQuartiles{
                    groupQuartiles()
                }
            }
            .onChange(of: shouldRestartLevel){
                restartLevel()
            }
            
        }.navigationBarBackButtonHidden(true)
        
        
    }
    
    
    func loadLevel(){
        // we want to start levels off of level 1 not 0
//        print("CurrentLevel: \(currentLevel + 1)")
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
        if canSubmit {
            print("can submit!")
            scoreToBeat = fetchedLevel!.score >= 15 ? 100 : 15
            withAnimation(.spring(response: 0.4, dampingFraction: 0.6)){
                
                // 1. Combine the words and turn it green
                // 2. enlarge the tile a bit
                // 3. submit it
                // 4. if Quartile do something extra ....
                foundWords.append(selectedTiles)
                print(foundWords)
                
                score += selectedTiles.score
                
                if selectedTiles.count == 4 {
                    foundQuartiles.append(contentsOf: selectedTiles)
                }
                
               
                if foundQuartiles.count / 4 == 5 && !foundAllQuartiles {
                    // Found all Quartiles
                    score += 40
                    foundAllQuartiles = true
                }
               
                selectedTiles.removeAll()
                groupQuartiles()
                
                //Fetch Level from SwiftData and save it in its container
                saveToSwiftData()
                
                
                
                if score >= scoreToBeat! {
                    showWinScreenView.toggle()
                    let currentLVL = fetchLevel(levelNumber: currentLevel, context: modelContext)!
                    currentLVL.completed = true

                    if let nextLVL = fetchLevel(levelNumber: currentLevel + 1, context: modelContext) {
                        nextLVL.unlocked = true
                    } else {
                        print("There is no next level")
                    }
                }
            }
        } else {
            // Incorrect Word
            
            showX = false
            let joinedTile = selectedTiles.joined()
            selectedTiles.removeAll()
            
            withAnimation(.spring(response: 0.2, dampingFraction: 0.45)){
                selectedTiles.append(joinedTile)
                
            }
            turnRed = true
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
                
                withAnimation(.spring(response: 0.2)){
                    showX = true
                    selectedTiles.removeAll()
                    turnRed = false
                }
                    
                    
                
                
            }
        }
        
    }
    func saveToSwiftData(){
        let currentLVL = fetchLevel(levelNumber: currentLevel, context: modelContext)!
        currentLVL.foundWords = foundWords
        currentLVL.foundQuartiles = foundQuartiles
        currentLVL.score = score
        currentLVL.rank = Rank.name(for: score)
    }
    
    
    
    func toggleGrouping(){
        withAnimation{
            isGroupingQuartiles.toggle()
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
            orderedTiles.append(quartile) // Add them to the back of the list so it looks like they auto go to the bottom.
        }
    }
    
    func setupNextLevel() {
        currentLevel += 1
        clearData()
    }
    func restartLevel(){
        clearData()
        saveToSwiftData()
        let currentLVL = fetchLevel(levelNumber: currentLevel, context: modelContext)!
        currentLVL.completed = false
        
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
            foundAllQuartiles = false
        }
    }
    
    func fetchLevel(levelNumber: Int, context: ModelContext) -> Level? {
        let descriptor = FetchDescriptor<Level>(
            predicate: #Predicate { $0.level == levelNumber }
        )
        do {
            let results = try context.fetch(descriptor)
            return results.first // Return the first match, or nil if not found
        } catch {
            print("Failed to fetch level: \(error)")
            return nil
        }
    }
    
}

#Preview {
    
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Level.self, configurations: config)
        container.mainContext.insert(Level(level: 0, foundWords: [[]], foundQuartiles: [], completed: false, rank: "Novice", score: 0, unlocked: false))
        container.mainContext.insert(Level(level: 1, foundWords: [[]], foundQuartiles: [], completed: true, rank: "Master", score: 101,unlocked: true))
        container.mainContext.insert(Level(level: 2, foundWords: [[]], foundQuartiles: [], completed: false, rank: "Master", score: 101, unlocked: true))
        container.mainContext.insert(Level(level: 3, foundWords: [[]], foundQuartiles: [], completed: false, rank: "Master", score: 101, unlocked: true))
        container.mainContext.insert(Level(level: 4, foundWords: [[]], foundQuartiles: [], completed: false, rank: "Master", score: 101, unlocked: true))
        container.mainContext.insert(Level(level: 5, foundWords: [[]], foundQuartiles: [], completed: false, rank: "Master", score: 101, unlocked: false))
        container.mainContext.insert(Level(level: 6, foundWords: [[]], foundQuartiles: [], completed: false, rank: "Master", score: 101, unlocked: false))
        return ContentView(score: 0, currentLevel: 0, foundWords: [[String]](), foundQuartiles: [String]())
            .modelContainer(container)
    } catch {
        return Text("Failed to create container: \(error.localizedDescription)")
    }
}
