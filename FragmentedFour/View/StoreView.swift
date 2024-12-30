//
//  StoreView.swift
//  FragmentedFour
//
//  Created by Brody on 12/5/24.
//

import SwiftUI
import SwiftData
import AVFoundation

@Model
class Pack : Identifiable, ObservableObject {
    var name: String
    var unlocked: Bool
    var price: Int
    var id: Int
    var levels: [Int] // ACCOUNT FOR ZERO INDEX lvls 1, 2, 3, 4 - > 0, 1 ,2, 3
    
    init(name: String, unlocked: Bool, price: Int, id: Int, levels: [Int]) {
        self.name = name
        self.unlocked = unlocked
        self.price = price
        self.id = id
        self.levels = levels
    }
}

struct StoreView: View {
    @State private var mainColor = AppColors.coreBlue
    
    // Packs
    private var columns = Array(repeating: GridItem.init(.flexible(), spacing: 1), count: 2)
    @Query(sort: [SortDescriptor(\Pack.id)]) var packs: [Pack]
    
    // UserData
    @EnvironmentObject var userData: UserData
    @EnvironmentObject var globalAudio: GlobalAudioSettings
    @Environment(\.modelContext) var modelContext
    @Query var levels: [Level]
    @State private var rankLocal: String?
    @State private var totalPtsLocal: Int?
    
    // Preview Handling
    @Environment(\.dismiss) var dismiss
    @State private var pressedDict: [String: Bool] = [:]
    @State private var pressedPack: Pack? {
        didSet {
            // Update pressedPackName and pressedPackPrice when pressedPack changes
            print("Pressed pack updated: \(pressedPack?.name ?? "nil"), \(pressedPack?.price ?? -1)")
        }
    }
    @State private var showWindow: Bool = false
    var pressedPackName: String {
        pressedPack?.name ?? "something"
    }
    var pressedPackPrice: Int{
        pressedPack?.price ?? 0
    }
    
    @State private var packViewID = UUID() // for rerendering
    
    // Audio
    @State private var audioPlayer: AVAudioPlayer? = nil

    
    var body: some View {
        ZStack{
            AppColors.body.ignoresSafeArea()
            VStack{
                ZStack{
                    mainColor.ignoresSafeArea()
                    Color.gray.opacity(showWindow ? 0.6 : 0.0).edgesIgnoringSafeArea(.all)
                        .onTapGesture {
                            withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
                                showWindow = false // Dismiss on background tap
                            }
                        }
                    // WHITE BOX
                    VStack{
                        ZStack(alignment: .top){
                            HStack(alignment: .firstTextBaseline){
                                Image(systemName: "arrowshape.turn.up.backward.fill")
                                    .resizable()
                                    .frame(width: 40, height: 40)
                                    .foregroundColor(.white)
                                    .background(
                                        Image(systemName: "arrowshape.turn.up.backward.fill")
                                            .resizable()
                                            .frame(width: 40, height: 40)
                                            .foregroundColor(.gray)
                                            .offset(y: 4)
                                    )
                                    .padding(.leading, 20)
                                    .onTapGesture {
                                        globalAudio.playSoundEffect(for: "BackBubble", audioPlayer: &audioPlayer)
                                        dismiss()
                                    }
                                Spacer()
                            }
                            .padding(.top, 55)
                            
                            VStack{
                                Text("Store")
                                    .foregroundStyle(.white)
                                    .font(.system(size: 40).bold())
                                    .offset(y: 54)
                                    .background (
                                        Text("Store")
                                            .foregroundStyle(.gray)
                                            .font(.system(size: 40).bold())
                                            .offset(y: 57)
                                    )
                                    
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color.white)
                                    .frame(width: UIScreen.main.bounds.width * 0.84, height: UIScreen.main.bounds.height * 0.10)
                                    .overlay(
                                        ZStack{
                                            HStack(alignment: .top) {
                                                VStack(alignment: .leading) {
                                                    Text("Avg Rank     ")
                                                        .bold()
                                                        .font(.system(size:14))
                                                    + Text("\(rankLocal ?? "Novice")")
                                                        .bold()
                                                        .font(.system(size: 28))
                                                        .foregroundStyle(mainColor)
                                                    
                                                    
                                                        
                                                    Spacer()
                                                        .frame(height: 10)
                                                    HStack{
                                                        Text("Total Fragments") //place holder score for now
                                                            .bold()
                                                            .font(.system(size:14))
                                                        Spacer()
                                                            .frame(width: 0)
                                                        MoneyView()
                                                            .scaleEffect(0.6)
                                                            .offset(x: -10)
                                                        Spacer()
                                                            .frame(width: 0)
                                                        Text("\(String(totalPtsLocal ?? 0))")
                                                            .bold()
                                                            .foregroundColor(mainColor)
                                                            .font(.system(size: 23))
                                                            .offset(x: -20)
                                                    }
                                                    .frame(height: 10)
                                                    
                                                    Spacer()
                                                }
                                                .padding()
                                                Spacer()
                                            }
                                        }
                                    )
                                    .background(
                                        RoundedRectangle(cornerRadius: 10)
                                            .frame(width: UIScreen.main.bounds.width * 0.84, height: UIScreen.main.bounds.height * 0.10)
                                            .foregroundStyle(.gray.opacity(0.4))
                                            .offset(y:4)
                                    )
                                    .offset(y: 40)
                                    
                            }
                            .padding(.bottom, 20)
                            
                            
                            
                        }
                        
                    }
                }
                .frame(height: UIScreen.main.bounds.height * 0.08)
                
                Spacer()
                    .frame(height: 100)
                
                // REGULAR SCROLL VIEW
                ScrollView{ // Add ScrollView for scrolling
                LazyVGrid(columns: columns, spacing: 40) {
                    ForEach(packs, id: \.name) { pack in
                        ZStack{
                            VStack{
                                Text("Pack \(pack.id)")
                                    .bold()
                                    .fontDesign(.rounded)
                                    .font(.system(size: 24))
                                Spacer().frame(height: 40)
                                PackPile_View(name: pack.name)
                                //HELP WITH THIS
                                HStack(alignment: .center) {
                                    Text("\(pack.price)")
                                        .font(.system(size: 16))
                                        .bold()
                                        .frame(minWidth: 50)
                                        .padding(.leading, 20)
                                    Spacer()
                                        .frame(width: 0)
                                    MoneyView()
                                        .scaleEffect(0.6)
                                        .offset(x: -10)
                                }
                                .frame(height: 30)
                            }
                            .onTapGesture {
                                pressedPack = pack
                                packViewID = UUID() // Force view to refresh
                                DispatchQueue.main.asyncAfter(deadline: .now()) {
                                    withAnimation(.spring(response: 0.3)) {
                                        showWindow = true
                                        globalAudio.playSoundEffect(for: "BackBubble", audioPlayer: &audioPlayer)
                                    }
                                }
                            }
                            Image("SoldSign")
                                .resizable()
                                .frame(width: 120, height: 120)
                                .opacity(pack.unlocked ? 1.0 : 0.0)
                        }
                        .allowsHitTesting(pack.unlocked ? false : true)
                        
                        
                    }
                }
                .padding(.leading, 40)
                .padding(.trailing, 40)// Add padding around the grid
                }
                
                
            }
            
            // Pop Up View for purchase
            ZStack {
                VStack(spacing: 20) {
                    // Close button
                    HStack {
                        Circle()
                            .fill(AppColors.coreBlue)
                            .frame(width: 40, height: 40)
                            .overlay(
                                Image(systemName: "xmark")
                                    .foregroundColor(.white)
                                    .font(.headline)
                            )
                            .onTapGesture {
                                withAnimation(.spring(response: 0.3)) {
                                    globalAudio.playSoundEffect(for: "BackBubble", audioPlayer: &audioPlayer)
                                    showWindow = false
                                }
                            }
                        Spacer()
                    }
                    
                    if let pack = pressedPack {
                        PackPile_View(name: pack.name)
                            .scaleEffect(1.4)
                            .frame(height: 250)
                            .id(packViewID) // Force re-render
                    }
                    
                    
                    // Price and Purchase Button
                    HStack(spacing: 20) {
                        // Price display
                        ZStack {
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(style: StrokeStyle(lineWidth: 2))
                                .foregroundStyle(.black)
                            HStack {
                                Text("\(pressedPackPrice)")
                                    .font(pressedPackPrice < 999 ? .system(size: 24).bold() : .system(size: 18).bold())
                                    .foregroundStyle(.black)
                                    .padding(.leading, 20)
                                MoneyView()
                                    .scaleEffect(0.5)
                                    .padding(-10)
                                
                            }
                        }
                        .frame(width: 130, height: 50) // Uniform frame for ZStack
                        
                        ZStack {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(AppColors.coreBlue)
                            
                            Text("Purchase")
                                .font(.title3.bold())
                                .foregroundStyle(.white)
                                .fontDesign(.rounded)
                                .onTapGesture {
                                    purchasePack()
                                }
                        }
                        .frame(width: 130, height: 50)
                    }
                    .padding(.horizontal)
                }
                .padding()
                .frame(width: 300, height: 400)
                .background(Color.white)
                .cornerRadius(20)
                .shadow(radius: 10)
                

            }
            .opacity(showWindow ? 1 : 0)
            .scaleEffect(showWindow ? 1 : 0.8)

        }
        .onDisappear{
            print("disapeered")
        }
        .navigationBarBackButtonHidden(true)
        
        .task {
            for pack in packs {
                print("pack.name \(pack.name) ID: \(pack.id)")
                pressedDict[pack.name] = false
            }
            withAnimation(.spring(response: 0.3)){
                userData.updatePtsAndRank(levels: levels)
            }
            rankLocal = userData.avgRank
            totalPtsLocal = userData.totalPts
        }
        
    }
    
    func purchasePack() {
        guard let pack = pressedPack, totalPtsLocal ?? 0 >= pack.price else {
            globalAudio.playSoundEffect(for: "IncorrectSound", audioPlayer: &audioPlayer)
            return
        }
        checkAvailableLevelsUnlocked(context: modelContext)
        userData.unlockedLevels += 5
        for (_, num) in pack.levels.enumerated() {
            fetchLevelAndRedeem(num, context: modelContext)
        }
        withAnimation(.spring(response: 0.3, dampingFraction: 0.6)){
            pack.unlocked = true
        }
        print("The levels have been redeemed and can now be unlocked!")
        globalAudio.playSoundEffect(for: "Quartile", audioPlayer: &audioPlayer)
        
        withAnimation(.spring(response: 0.3)) {
            showWindow = false
        }
    }
    
    func fetchLevelAndRedeem(_ inputInt: Int, context: ModelContext, allPossibleUnlockedLevelsCompleted: Bool = false) {
        let descriptor = FetchDescriptor<Level>(
            predicate: #Predicate { $0.level == inputInt }
        )
        do {
            
            let results = try context.fetch(descriptor)
            let foundLevel = results.first
            print("attempting to redeem \(foundLevel!.level)")
            foundLevel?.redeemed = true
            
            if allPossibleUnlockedLevelsCompleted {
                print("foundLevel.unlocked = true")
                foundLevel?.unlocked = true
            }
            try! context.save()
            print("redeem saved!\n")
        } catch {
            print("Failed to fetch level: \(error)")
        }
    }
    
    func checkAvailableLevelsUnlocked (context: ModelContext){
        let unlockedLevels = userData.unlockedLevels
        let completedLevels = userData.completedLevels
        print("completedLevels = \(userData.completedLevels)")
        print("unlockedLevels amount \(unlockedLevels)")
        
        if unlockedLevels - completedLevels == 0 {
            print("Entered conditional for unlocking first level of pack")
            let descriptor = FetchDescriptor<Level>(
                predicate: #Predicate { $0.level == unlockedLevels } // apply zero index
            )
            do {
                let results = try context.fetch(descriptor)
                let foundLevel = results.first
                print("Level \(foundLevel!.level) is completed -> \(foundLevel!.completed) LevelScore: \(foundLevel!.score)")
                foundLevel!.unlocked = true
                try! context.save()
                print("redeem saved!\n")
            } catch {
                print("Failed to fetch level: \(error)")
            }
            
        }
        else{
            print("nothing happened")
        }
    }
    
    
    
    
}

#Preview {

    let config = ModelConfiguration(for: Pack.self, isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Pack.self, configurations: config)
    let userData = UserData()
    
    
    try! container.mainContext.delete(model: Pack.self)


    container.mainContext.insert(Pack(name: "6-10", unlocked: true, price: 200, id: 1, levels: [5, 6, 7, 8, 9]))
    container.mainContext.insert(Pack(name: "11-15", unlocked: false, price: 600, id: 2, levels: [10, 11, 12, 13, 14]))
    container.mainContext.insert(Pack(name: "16-20", unlocked: false, price: 1000, id: 3, levels: [15, 16, 17, 18, 19]))
    container.mainContext.insert(Pack(name: "21-25", unlocked: false, price: 1300, id: 4, levels: [20, 21, 22, 23, 24]))
    
    
    
    do {
        try container.mainContext.save()
    }
    catch{
        print("couldn't save context")
    }
        

    return StoreView()
            .modelContainer(container)
            .environmentObject(userData)

}

