//
//  SideBarView.swift
//  FragmentedFour
//
//  Created by Brody on 11/27/24.
//

import SwiftUI

struct SideBarView: View {
    @Binding var shouldRestartLevel: Bool
    @Environment(\.dismiss) var dismiss
    var body: some View {
        
        VStack(alignment: .center) {
            Spacer()
                .frame(height: 60)
            Text("Menu")
                .font(.title.bold())
                .foregroundStyle(.white)
                .padding()
                
            
            Divider()
                .frame(width: UIScreen.main.bounds.width * 2/4)
                .padding(.horizontal)
            
            VStack(alignment: .center){
                Spacer()
                    .frame(height: 20)
                
                Button(action: {
                    shouldRestartLevel.toggle()
                }, label:{
                    Text("Restart")
                        .font(.body.bold())
                        .foregroundStyle(.white)
                        .padding()
                        
                })
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(.quaternary)
                )
                
                Spacer()
                    .frame(height: 20)
                
                Text("Level Select")
                    .font(.body.bold())
                    .foregroundStyle(.white)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(.quaternary)
                    )
                    .onTapGesture {
                        //dismiss back to LevelSelectView
                        dismiss()
                    }
                Spacer()
                    .frame(height: 20)
                
                Button(action:{}, label:{
                    Image(systemName: "house")
                        .foregroundStyle(.white)
                        .padding()
                        
                })
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(.quaternary)
                )
                    
            }
            
            
           
               
                
            Spacer()
        }
        .background(Color.blue)
        .cornerRadius(10)
        .edgesIgnoringSafeArea(.all)
        
        
    }
}

#Preview {
    ZStack {
        Color.red.ignoresSafeArea()
        SideBarView(shouldRestartLevel: .constant(false))
    }
}
