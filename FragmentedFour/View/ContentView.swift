//
//  ContentView.swift
//  FragmentedFour
//
//  Created by Brody on 11/26/24.
//



import AVFoundation
import StoreKit
import SwiftData
import SwiftUI

struct ContentView: View {
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var Dismiss
    @EnvironmentObject var userData: UserData
    @EnvironmentObject var globalAudio: GlobalAudioSettings
    @Environment(\.requestReview) var requestReview
    @Query var LevelClass: [Level]
    
    let levels: [[String]] = Bundle.main.decode("levels.json")
    @State private var currentLVL: Level?
    
    @State private var tiles = [String]()
    @State private var selectedTiles = [String]()
    @State private var orderedTiles = [String]()
    @State private var intendedWords = [String]()
    
    @State private var turnRed: Bool = false
    @State private var turnGreen: Bool = false
    @State private var showX: Bool = true
    @State private var quartileCount: Int = 1
    @State private var submissionState: Bool = false
    @State private var foundQuartile: Bool = false
    @State private var makeTilesLarge: Bool = false
    
    @State private var isGroupingQuartiles = true
    
    // Pass through vals from LevelView
    @State var score: Int
    @State var currentLevel: Int
    @State var foundWords: [[String]]
    @State var foundQuartiles: [String]
    
    @State private var showWinScreenView = false
    @State private var winScreenOffQuartiles = false
    @State private var foundAllQuartiles = false
    
    @State private var showSideBarView = false
    @State private var sideBarDragOffset = CGSize.zero
    @State var shouldRestartLevel = false
    
    @State private var audioPlayer: AVAudioPlayer?
    
    @State private var mainColor: Color = Color.gray
    @Binding var navPath: NavigationPath
    
    var bubbleSoundList: [String] = ["BubbleSound1", "BubbleSound2", "BubbleSound3", "BubbleSound4"]
    
    
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
                            SideBarView(shouldRestartLevel: $shouldRestartLevel, navPath: $navPath)
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
                                                    //                                                    print("showSideBarView -> \(showSideBarView)")
                                                    
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
                                globalAudio.playSoundEffect(for: "BackBubble", audioPlayer: &audioPlayer)
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
                                    .padding(.leading, 20)
                                    .background(
                                        Image(systemName: "equal")
                                            .resizable()
                                            .frame(width: 40, height: 20)
                                            .foregroundStyle(.gray)
                                            .padding(.leading, 20)
                                            .offset(y:2)
                                    )
                            }
                        )
                        .offset(y: -70)
                        .allowsHitTesting(!submissionState)
                        
                        RankView(score: score)
                    }
                    .frame(maxWidth: 100)
                    Spacer()
                    ScoreView(score: score)
                        .frame(maxWidth: .infinity)
                    Spacer()
                    
                    ZStack(alignment: .leading){
                        (
                            Text("Level ")
                                .font(.title.bold())
                                .foregroundStyle(.white)
                            +
                            Text("\(currentLevel + 1)")
                                .font(currentLevel < 9 ? .title.bold() : .title3.bold())
                                .foregroundStyle(.white)
                        )
                        .offset(y: -70)
                        .background(
                            (
                                Text("Level ")
                                    .font(.title.bold())
                                    .foregroundStyle(.gray)
                                +
                                Text("\(currentLevel + 1)")
                                    .font(currentLevel < 9 ? .title.bold() : .title3.bold())
                                    .foregroundStyle(.gray)
                            )
                            .offset(y: -68)
                        )
                        
                        QuartilesFoundView(quartiles: foundQuartiles.count / 4)
                    }
                    .frame(maxWidth: 100)
                    
                }
                .padding()
                .padding(.bottom, 60)
                .foregroundStyle(.white)
                .background(foundQuartile ? .green : mainColor)
                
                
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
                                Text(foundAllQuartiles && score <= 100 ? "You have found all Fragment 4s!" : score <= 100 ? "You scored enough points!" : "You reached the highest rank!")
                                    .font(.body.bold())
                                    .foregroundColor(.black.opacity(0.5))
                                Text("Proceed to the next level?")
                                    .font(.body.bold())
                                    .foregroundColor(.black.opacity(0.5))
                                
                            }
                            Spacer()
                                .frame(height: 20)
                            Button(action: {
                                Dismiss()
                            }, label:{
                                Text(navPath.count == 2 ? "Level Select" : "Main Menu")
                                    .font(.title2.bold())
                                    .foregroundStyle(.white)
                                    .frame(minWidth: 180, maxWidth: 240, maxHeight: 50)
                                    .background(mainColor)
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
                                    .background(mainColor)
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                                    .padding(.horizontal)
                            })
                            Spacer()
                                .frame(minHeight: 80)
                                .frame(minHeight: 80)
                        }
                        .onAppear(perform: {globalAudio.playSoundEffect(for: "Victory", audioPlayer: &audioPlayer)})
                        
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .frame(maxWidth: .infinity, minHeight: 400, maxHeight: 400)
                        .background(AppColors.body)
                        .cornerRadius(10)
                        .shadow(color: Color(.black.opacity(0.25)), radius: 10)
                        .padding(.horizontal)
                        .zIndex(2)
                        .padding(.top ,100)
                    }
                    
                    WordsFoundView(words: foundWords, mainColor: mainColor)
                        .zIndex(1)
                        .opacity(showWinScreenView ? 0 : 1)
                    
                    VStack{
                        
                        //hidden placeholder
                        WordsFoundView(words: foundWords, mainColor: mainColor)
                            .hidden()
                        
                        Spacer()
                        
                        HStack{
                            if selectedTiles.isEmpty{
                                // hidden tile so that the UI doesnt move...
                                SelectedTileView(text: "aa", turnRed: $turnRed, turnGreen: $turnGreen, mainColor: mainColor)
                                
                                    .hidden()
                            } else {
                                ForEach(selectedTiles, id:
                                            \.self) { tile in
                                    Button {
                                        deselect(tile)
                                    } label : {
                                        SelectedTileView(text: tile, turnRed: $turnRed, turnGreen: $turnGreen, mainColor: mainColor)
                                        
                                        
                                    }
                                }
                                
                                Button("Clear", systemImage: "xmark.circle", action: {
                                    clearSelected()
                                    globalAudio.playSoundEffect(for: "BackBubble", audioPlayer: &audioPlayer)
                                })
                                .opacity(showX ? 1.0 : 0.0)
                                .animation(nil, value: showX)
                                .labelStyle(.iconOnly)
                                .symbolVariant(.fill)
                                .foregroundStyle(turnGreen ? .green : mainColor)
                                
                            }
                        }
                        Spacer()
                        
                        // grid groes vertically as more items are added
                        LazyVGrid(columns: gridLayout) {
                            ForEach(orderedTiles, id: \.self){ tile in
                                Button {
                                    select(tile)
                                    //                                    playSound(for: bubbleSoundList.randomElement())
                                } label: {
                                    TileView(
                                        text: tile,
                                        isSelected: selectedTiles.contains(tile),
                                        isHighlighted: isGroupingQuartiles && foundQuartiles.contains(tile),
                                        mainColor: mainColor,
                                        forMainMenu: false
                                    )
                                    .transition(.identity)
                                    .scaleEffect(makeTilesLarge ? 1.2 : 1.0)
                                }
                                //Custom Style preventing button from going gray on disable
                                .buttonStyle(NoGrayOutButtonStyle())
                                
                                .disabled(submissionState)
                                
                                
                            }
                        }
                        .opacity(showWinScreenView ? 0 : 1)
                        
                        Spacer()
                        
                        HStack{
                            Button(action: shuffletiles){
                                Label("Shuffles", systemImage: "shuffle")
                                    .padding(5)
                                    .font(.headline)
                                    .foregroundStyle(mainColor)
                            }
                            .buttonStyle(.bordered)
                            .buttonBorderShape(.circle)
                            
                            
                            Spacer()
                            
                            Button(action: submit){
                                Label("Submit", systemImage: "checkmark")
                                    .padding(10)
                                    .font(.title)
                            }
                            .tint(mainColor)
                            .buttonStyle(.borderedProminent)
                            .buttonBorderShape(.circle)
                            .disabled(selectedTiles.isEmpty)
                            .disabled(submissionState)
                            
                            
                            Spacer()
                            
                            Button(action: toggleGrouping){
                                Label("Group", systemImage: "list.star")
                                    .padding(5)
                                    .font(.title)
                            }
                            .buttonStyle(.bordered)
                            .buttonBorderShape(.circle)
                            .tint(isGroupingQuartiles ? mainColor : nil)
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
                currentLVL = fetchLevel(levelNumber: currentLevel, context: modelContext)!
                mainColor = currentLVL!.score >= 100 ? AppColors.masterRed : AppColors.coreBlue
                loadLevel()
                if isGroupingQuartiles{
                    groupQuartiles()
                }
            }
            .onDisappear {
                print("stopping audio?")
                globalAudio.stopAudio(&audioPlayer)
            }
            .onChange(of: shouldRestartLevel){
                restartLevel()
            }
            
            
        }
        .navigationBarBackButtonHidden(true)
        .interactiveDismissDisabled()
        
        
        
        
        
    }
    
    
    
    func loadLevel(){
        tiles = levels[currentLevel].shuffled()
        orderedTiles = tiles
        findIntendWords(for: tiles)
    }
    func clearSelected(){
        selectedTiles.removeAll()
    }
    func select(_ tile: String){
        guard selectedTiles.count < 4 else { return }
        guard selectedTiles.contains(tile) == false else { return }
        
        selectedTiles.append(tile)
        globalAudio.playSoundEffect(for: bubbleSoundList.randomElement()!, audioPlayer: &audioPlayer)
    }
    func deselect(_ tile: String){
        selectedTiles.removeAll { $0 == tile }
        globalAudio.playSoundEffect(for: "BackBubble", audioPlayer: &audioPlayer)
    }
    func shuffletiles() {
        //        globalAudio.playSoundEffect(for: "BackBubble", audioPlayer: &audioPlayer)
        withAnimation{
            tiles.shuffle()
            orderedTiles = tiles
            groupQuartiles()
        }
    }
    
    func combineTiles(completion: @escaping () -> Void) {
        guard selectedTiles.count > 1 else {
            if quartileCount == 4{
                globalAudio.playSoundEffect(for: "Quartile", audioPlayer: &audioPlayer)
                withAnimation(.spring(response: 0.2)){
                    foundQuartile = true
                    
                }
            }
            if quartileCount == 1{
                globalAudio.playSoundEffect(for: "CorrectSound", audioPlayer: &audioPlayer)
            }
            quartileCount = 1
            completion()
            return
        }
        quartileCount += 1
        let firstTwoCombined = selectedTiles[0] + selectedTiles[1]
        selectedTiles.removeFirst(2)
        
        
        withAnimation(.spring(response: 0.3, dampingFraction: 0.4)){
            selectedTiles.insert(firstTwoCombined, at: 0)
            globalAudio.playSoundEffect(for: "CorrectSound", audioPlayer: &audioPlayer)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            self.combineTiles(completion: completion)
        }
    }
    
    func winScreen(level: Level){
        print("level threshhold: \(level.levelThreshhold)")
        if level.levelThreshhold == 15 && score >= 15{
            withAnimation(.spring(response: 0.3, dampingFraction: 0.5)){
                showWinScreenView.toggle()
            }
            level.completed = true
            level.levelThreshhold = 100
            userData.incrementReviewCount(reviewAction: requestReview)
            
            if let nextLVL = fetchLevel(levelNumber: currentLevel + 1, context: modelContext) {
                if nextLVL.redeemed{
                    nextLVL.unlocked = true
                }
            } else {
                print("There is no next level")
            }
        }
        // Finds all the quartiles on the view for the first time.
        else if currentLVL!.foundAllWords == false && currentLVL!.foundQuartiles.count / 4 == 5 {
            print("Show View for finding all the quartiles")
            currentLVL!.foundAllWords = true
            foundAllQuartiles = true
            if score >= 100 { withAnimation(.spring(response: 0.5)){ mainColor = AppColors.masterRed } }
            withAnimation(.spring(response: 0.3, dampingFraction: 0.5)){
                showWinScreenView.toggle()
            }
        }
        
        else if level.levelThreshhold == 100 && score >= 100{
            withAnimation(.spring(response: 0.3, dampingFraction: 0.6)){
                mainColor = AppColors.masterRed
            }
            level.levelThreshhold = 1000
            withAnimation(.spring(response: 1.0, dampingFraction: 0.4)){
                showWinScreenView.toggle()
            }
        }
    }
    
    func submit() {
        submissionState = true
        // Correct Input
        if canSubmit {
            showX = false
            withAnimation(.spring(response: 0.4, dampingFraction: 0.6)){
                foundWords.append(selectedTiles)
                turnGreen = true
                score += selectedTiles.score
                
                // If user lands on intended quartile
                if selectedTiles.count == 4 && intendedWords.contains(selectedTiles.joined()) {
                    print("found intended Quartile")
                    foundQuartiles.append(contentsOf: selectedTiles)
                }
                combineTiles {
                    groupQuartiles()
                    print("foundQuartiles.count \(foundQuartiles.count)\n\(foundQuartiles)")
                    saveToSwiftData()
                    if currentLVL!.foundQuartiles.count / 4 == 5 && currentLVL!.foundAllWords == false {
                        
                        score += 40
                        currentLVL!.score = score
                        
                        
                    }
                    
                    
                    
                    // Reset values
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0){
                        withAnimation(.spring(response: 0.2, dampingFraction: 0.45)){
                            selectedTiles.removeAll()
                            turnGreen = false
                            showX = true
                            foundQuartile = false
                            
                        }
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.8){
                        submissionState = false
                        winScreen(level: currentLVL!)
                    }
                    
                }
            }
        } else {
            // Incorrect Input
            showX = false
            let joinedTile = selectedTiles.joined()
            selectedTiles.removeAll()
            
            withAnimation(.spring(response: 0.2, dampingFraction: 0.45)){
                selectedTiles.append(joinedTile)
                
            }
            turnRed = true
            globalAudio.playSoundEffect(for: "IncorrectSound", audioPlayer: &audioPlayer)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
                
                withAnimation(.spring(response: 0.2)){
                    showX = true
                    selectedTiles.removeAll()
                    turnRed = false
                }
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.9){
                submissionState = false
            }
        }
    }
    
    func saveToSwiftData(){
        currentLVL!.foundWords = foundWords
        currentLVL!.foundQuartiles = foundQuartiles
        currentLVL!.score = score
        currentLVL!.rank = Rank.name(for: score)
        userData.updatePtsAndRank(levels: LevelClass)
    }
    
    
    
    func toggleGrouping(){
        //        globalAudio.playSoundEffect(for: "BackBubble", audioPlayer: &audioPlayer)
        withAnimation{
            isGroupingQuartiles.toggle()
            if isGroupingQuartiles{
                groupQuartiles()
            } else {
                orderedTiles = tiles
            }
        }
        
                    
    }
    
    func groupQuartiles() {
        guard isGroupingQuartiles else { return }
        for quartile in foundQuartiles {
            withAnimation{
                orderedTiles.removeAll(where: { $0 == quartile })
                orderedTiles.append(quartile)
            }        }
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
            currentLVL!.foundAllWords = false
            currentLVL!.levelThreshhold = 15
            currentLVL!.score = 0
            currentLVL!.rank = "Novice"
            currentLVL!.foundWords = [[String]]()
            currentLVL!.foundQuartiles = [String]()
            mainColor = AppColors.coreBlue
            userData.updatePtsAndRank(levels: LevelClass)
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
    
    
    func findIntendWords(for inputWords: [String]){
        intendedWords.removeAll()
        var wordsList = levels[currentLevel] // has 16 strings in [String]
        for _ in 0...4 {
            let word = wordsList[0] + wordsList[1] + wordsList[2] + wordsList[3]
            wordsList.removeFirst(4)
            intendedWords.append(word)
        }
        
    }
}

#Preview {
    
    @Previewable @StateObject var userData = UserData()
    @Previewable @StateObject var globalAudio = GlobalAudioSettings()
    @Previewable @State var navPath = NavigationPath()
    
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Level.self, configurations: config)
    container.mainContext.insert(Level(level: 0, foundWords: [[String]](), foundQuartiles: [String](), completed: false, rank: "Novice", score: 0, unlocked: false))
    container.mainContext.insert(Level(level: 1, foundWords: [[String]](), foundQuartiles: [String](), completed: true, rank: "Master", score: 101,unlocked: true))
    container.mainContext.insert(Level(level: 2, foundWords: [[String]](), foundQuartiles: [String](), completed: false, rank: "Master", score: 101, unlocked: true))
    container.mainContext.insert(Level(level: 3, foundWords: [[String]](), foundQuartiles: [String](), completed: false, rank: "Master", score: 101, unlocked: true))
    container.mainContext.insert(Level(level: 4, foundWords: [[String]](), foundQuartiles: [String](), completed: false, rank: "Master", score: 101, unlocked: true))
    container.mainContext.insert(Level(level: 5, foundWords: [[String]](), foundQuartiles: [String](), completed: false, rank: "Master", score: 101, unlocked: false))
    container.mainContext.insert(Level(level: 6, foundWords: [[String]](), foundQuartiles: [String](), completed: false, rank: "Master", score: 101, unlocked: false))
    return ContentView(score: 0, currentLevel: 0, foundWords: [[String]](), foundQuartiles: [String](), navPath: $navPath)
        .environment(userData)
        .modelContainer(container)
    
    //    } catch {
    //        return Text("Failed to create container: \(error.localizedDescription)")
    //    }
}
