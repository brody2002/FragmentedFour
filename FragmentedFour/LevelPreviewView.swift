//
//  LevelPreviewView.swift
//  FragmentedFour
//
//  Created by Brody on 12/4/24.
//

import SwiftUI

struct LevelPreviewView: View {
    @State private var screenHeight = UIScreen.main.bounds.height
    @State private var screenWidth = UIScreen.main.bounds.width
    var body: some View {
        ZStack{
            Color.white.ignoresSafeArea()
            VStack{
                Spacer()
                    .frame(height: screenHeight * 0.01)
                RoundedRectangle(cornerRadius: 10)
                    .fill(AppColors.body)
                    .frame(width: screenWidth * 0.87, height: screenHeight * 0.42)
                    .overlay(
                        ZStack{
                            VStack{
                                HStack{
                                    Spacer()
                                        .frame(width: screenWidth * 0.1)
                                    Image(systemName: "trophy.fill")
                                        .resizable()
                                        .frame(width: 100, height: 100)
                                    Spacer()
                                    VStack{
                                        Text("83 Pts")
                                        Text("Rank Wizard")
                                    }
                                    Text("")
                                    Spacer()
                                }
                                Spacer()
                                    .frame(height: 20)
                                Text("Completed Fragments of 4")
                                Text("4")
                            }
                        }
                    )
                
                Spacer()
                RoundedRectangle(cornerRadius: 10)
                    .fill(AppColors.body)
                    .frame(width: screenWidth * 0.87, height: screenHeight * 0.14)
                    .overlay(
                            ScrollView{
                                VStack{
                                    Text("Word1")
                                    Text("Word2")
                                    Text("Word3")
                                    Text("Word4")
                                    Text("Word5")
                                    Text("Word6")
                                }
                            }
                    )
                Spacer()
                    .frame(height: screenHeight * 0.01)
            }
        }
        .frame(width: UIScreen.main.bounds.width * 0.9, height: UIScreen.main.bounds.height * 0.6)
        .cornerRadius(10)
    }
}

#Preview {
    ZStack{
        AppColors.coreBlue.ignoresSafeArea()
        LevelPreviewView()
    }
    
}
