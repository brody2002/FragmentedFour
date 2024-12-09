    //
    //  StoreView.swift
    //  FragmentedFour
    //
    //  Created by Brody on 12/5/24.
    //

    import SwiftUI
    import SwiftData

    @Model
    class Pack : Identifiable, ObservableObject {
        var name: String
        var unlocked: Bool
        var price: Int
        var id: Int
        
        init(name: String, unlocked: Bool, price: Int, id: Int) {
            self.name = name
            self.unlocked = unlocked
            self.price = price
            self.id = id
        }
    }

    //TODO: Create the 4 packs that I have currnently in swiftdata

    struct StoreView: View {
        @State private var mainColor = AppColors.coreBlue
        
        // Packs
        private var columns = Array(repeating: GridItem.init(.flexible(), spacing: 1), count: 2)
        @Query(sort: [SortDescriptor(\Pack.id)]) var packs: [Pack]
        
        // UserData
        @EnvironmentObject var userData: UserData
        @Query var levels: [Level]
        @State private var rankLocal: String?
        @State private var totalPtsLocal: Int?
        
        var body: some View {
            ZStack{
                AppColors.body.ignoresSafeArea()
                
                VStack{
                    ZStack{
                        mainColor.ignoresSafeArea()
                        VStack{
                            ZStack(alignment: .top){
                                VStack{
                                    Text("Store")
                                        .foregroundStyle(.white)
                                        .font(.system(size: 40).bold())
                                        .offset(y: 54)
                                    
                                        
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
                    
                    ScrollView{ // Add ScrollView for scrolling
                    LazyVGrid(columns: columns, spacing: 20) {
                        ForEach(packs, id: \.name) { pack in
                            VStack{
                                RoundedRectangle(cornerRadius: 10)
                                    .frame(width: 100, height: 100)
                                    .overlay(
                                        Text("Pack \(pack.name)")
                                            .foregroundStyle(mainColor)
                                            .bold()
                                    )
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
                            .frame(width: 110)
                        }
                    }
                        .padding(.leading, 40)
                        .padding(.trailing, 40)// Add padding around the grid
                    }
                }
            }
            .navigationBarBackButtonHidden(true)
            .task {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.6)){
                    userData.updatePtsAndRank(levels: levels)
                }
                rankLocal = userData.avgRank
                totalPtsLocal = userData.totalPts
            }
            
        }
    }

#Preview {
    
        let config = ModelConfiguration(for: Level.self, Pack.self)
        let container = try! ModelContainer(for: Level.self, Pack.self, configurations: config)
        let userData = UserData()
        container.mainContext.insert(Level(level: 0, foundWords: [[String]](), foundQuartiles: [String](), completed: false, rank: "Novice", score: 0, unlocked: true))
        container.mainContext.insert(Level(level: 1, foundWords: [[String]](), foundQuartiles: [String](), completed: false, rank: "Novice", score: 0, unlocked: true))
        container.mainContext.insert(Level(level: 2, foundWords: [[String]](), foundQuartiles: [String](), completed: false, rank: "Novice", score: 0, unlocked: true))
        container.mainContext.insert(Level(level: 3, foundWords: [[String]](), foundQuartiles: [String](), completed: false, rank: "Novice", score: 0, unlocked: true))
        container.mainContext.insert(Level(level: 4, foundWords: [[String]](), foundQuartiles: [String](), completed: false, rank: "Novice", score: 0, unlocked: true))
        container.mainContext.insert(Level(level: 5, foundWords: [[String]](), foundQuartiles: [String](), completed: false, rank: "Novice", score: 0, unlocked: true))
        container.mainContext.insert(Level(level: 1, foundWords: [[String]](), foundQuartiles: [String](), completed: false, rank: "Novice", score: 0, unlocked: true, redeemed: false))
    
    container.mainContext.insert(Pack(name: "6-10", unlocked: false, price: 200, id: 1))
    container.mainContext.insert(Pack(name: "11-15", unlocked: false, price: 600, id: 2))
    container.mainContext.insert(Pack(name: "16-20", unlocked: false, price: 1000, id: 3))
    container.mainContext.insert(Pack(name: "21-25", unlocked: false, price: 1300, id: 4))
        

    return StoreView()
            .modelContainer(container)
            .environmentObject(userData)
    
}

