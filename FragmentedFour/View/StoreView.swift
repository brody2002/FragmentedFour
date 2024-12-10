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
    
    // Preview Handling
    @State private var pressedDict: [String: Bool] = [:]
    @State private var pressedPack: Pack?
    @State private var showWindow: Bool = false
    var pressedPackName: String {
        pressedPack?.name ?? "nothing"
    }
    var pressedPackPrice: Int{
        pressedPack?.price ?? 0
    }

    
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
                LazyVGrid(columns: columns, spacing: 40) {
                    ForEach(packs, id: \.name) { pack in
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
                            print("Pressed pack updated: \(pressedPack?.name ?? "nil"), \(pressedPack?.price ?? -1)")
                            DispatchQueue.main.async {
                                withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                                    showWindow = true
                                }
                            }
                        }
                    }
                }
                    .padding(.leading, 40)
                    .padding(.trailing, 40)// Add padding around the grid
                }
                
                
            }
            
            // Pop Up View
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
                                withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
                                    showWindow = false
                                }
                            }
                        Spacer()
                    }
                    
                    // Pack pile
                    PackPile_View(name: pressedPackName)
                        .scaleEffect(1.4)
                        .frame(height: 250) // Adjust height to center content
                    
                    // Price and Purchase Button
                    HStack(spacing: 20) {
                        // Price display
                        ZStack {
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(style: StrokeStyle(lineWidth: 2))
                                .foregroundStyle(.black)
                            HStack {
                                Spacer()
                                Text("\(pressedPackPrice) 💰")
                                    .font(.title3.bold())
                                    .foregroundStyle(.black)
                                    .padding(.leading, 20)
                                Spacer()
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
            .animation(.spring(response: 0.5, dampingFraction: 0.8), value: showWindow)

        }
        .navigationBarBackButtonHidden(true)
        .task {
//            // init dict for view
            for pack in packs {
                print("pack.name \(pack.name) ID: \(pack.id)")
                pressedDict[pack.name] = false
            }
            withAnimation(.spring(response: 0.3, dampingFraction: 0.6)){
                userData.updatePtsAndRank(levels: levels)
            }
            rankLocal = userData.avgRank
            totalPtsLocal = userData.totalPts
        }
        
    }
}

#Preview {

    let config = ModelConfiguration(for: Pack.self, isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Pack.self, configurations: config)
    let userData = UserData()
    
    try! container.mainContext.delete(model: Pack.self)

    container.mainContext.insert(Pack(name: "6-10", unlocked: false, price: 200, id: 1))
    container.mainContext.insert(Pack(name: "11-15", unlocked: false, price: 600, id: 2))
    container.mainContext.insert(Pack(name: "16-20", unlocked: false, price: 1000, id: 3))
    container.mainContext.insert(Pack(name: "21-25", unlocked: false, price: 1300, id: 4))
    
    
    
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

