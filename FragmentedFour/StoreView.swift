//
//  StoreView.swift
//  FragmentedFour
//
//  Created by Brody on 12/5/24.
//

import SwiftUI

struct StoreView: View {
    @State private var mainColor = AppColors.coreBlue
    private var columns = Array(repeating: GridItem.init(.flexible(), spacing: 40), count: 2)
    private var packs: [String] = ["6-10", "11-15", "16-20", "21-25"]
    
    
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
                                                    Text("Avg Rank   ")
                                                        .bold()
                                                        .font(.system(size:14))
                                                    + Text("Wizard")
                                                        .bold()
                                                        .font(.system(size: 28))
                                                        .foregroundStyle(mainColor)
                                                        
                                                    Spacer()
                                                        .frame(height: 10)
                                                    Text("Total Words") //place holder score for now
                                                        .bold()
                                                        .font(.system(size:14))
                                                    + Text("   3 💰")
                                                        .bold()
                                                        .foregroundColor(mainColor)
                                                        .font(.system(size: 23))
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
                LazyVGrid(columns: columns, spacing: 100) {
                    ForEach(packs, id: \.self){ item in
                        ZStack{
                            RoundedRectangle(cornerRadius: 10)
                                .frame(width: 100, height: 100)
                                .overlay(
                                    Text("Pack \(item)")
                                        .foregroundStyle(mainColor)
                                        .bold()
                                )
                            
                        }
                    }
                }
                    .padding(.leading, 40)
                    .padding(.trailing, 40)// Add padding around the grid
                }
            }
        }
    }
}

#Preview {
    StoreView()
}
