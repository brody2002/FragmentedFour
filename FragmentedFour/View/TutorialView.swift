//
//  TutorialView.swift
//  FragmentedFour
//
//  Created by Brody on 12/10/24.
//

import SwiftUI

struct TutorialView: View {
    
    @State private var textPreview1: String = "The goal of the game is to create words using the fragments of text seen on the screen"
    @State private var textPreview2: String = "Words can be made from groups of fragments ranging from sizes of 1-4."
    @State private var textPreview3: String = "Words that form the color red mean that that they do not exist!"
    @State private var textPreview4: String = "Words that form the color green mean that you have successfully found a word. If you find 5 fragments of length 4, you are granted an additional 40 points!"
    @State private var textPreview5: String = "Build Fragment Points in order to unlock more levels!"
    
    var body: some View {
        ZStack{
            AppColors.coreBlue.ignoresSafeArea()
            VStack(alignment: .center){
                Spacer()
                    .frame(height: UIScreen.main.bounds.width * 0.05)
                Text("How To Play")
                    .foregroundStyle(.white)
                    .font(.title.bold())
                    .fontDesign(.rounded)
                    .background(
                        Text("How To Play")
                            .foregroundStyle(.gray)
                            .font(.title.bold())
                            .fontDesign(.rounded)
                            .offset(y: 3)
                    )
                
                Spacer()
                    .frame(height: UIScreen.main.bounds.width * 0.1)
                
                ZStack{
                    AppColors.darkBlue.opacity(0.6)
                    TabView {
                        slideView(stepNumber: 1, imageName: "Image1", description: textPreview1)
                        
                        slideView(stepNumber: 2, imageName: "Image2", description: textPreview2)
                        
                        slideView(stepNumber: 3, imageName: "Image3", description: textPreview3)
                        
                        slideView(stepNumber: 4, imageName: "Image4", description: textPreview4)
                        
                        slideView(stepNumber: 5, imageName: "Image5", description: textPreview5)
                    }
                    .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
                    .frame(width: UIScreen.main.bounds.width * 0.82, height: UIScreen.main.bounds.height * 0.68)
                    
                    
                }
                .frame(width: UIScreen.main.bounds.width * 0.88, height: UIScreen.main.bounds.height * 0.74)
                .cornerRadius(10)
                
                Spacer()
                
                
                
            }
        }
        .navigationBarBackButtonHidden(true)
    }
    
    func slideView (stepNumber: Int, imageName: String, description: String) -> some View {
        VStack{
            Text("Step \(stepNumber)")
                .foregroundStyle(AppColors.coreBlue)
                .font(.title2.bold())
                .background(
                    Text("Step \(stepNumber)")
                        .foregroundStyle(AppColors.darkBlue)
                        .font(.title2.bold())
                        .offset(y: 1)
                )
            Spacer()
                .frame(height: UIScreen.main.bounds.height * 0.03)
            Image(imageName)
                .resizable()
                .frame(width: UIScreen.main.bounds.width * 0.5, height: UIScreen.main.bounds.height * 0.46)
                .cornerRadius(10)
            Spacer()
                .frame(height: UIScreen.main.bounds.height * 0.02)
            Text("\(description)")
                .bold()
                .foregroundStyle(.white)
                .fontDesign(.rounded)
                .multilineTextAlignment(.center)
                .font(.system(size: imageName == "Image4" ? 14 : 20))
            Spacer()
            
            
        }
    }
    
}

#Preview {
    TutorialView()
}
