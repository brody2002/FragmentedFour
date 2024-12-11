//
//  SettingsView.swift
//  FragmentedFour
//
//  Created by Brody on 12/11/24.
//

import SwiftUI

struct SettingsView: View {
    var body: some View {
        ZStack{
            AppColors.coreBlue.ignoresSafeArea()
            VStack(alignment: .center){
                Text("Settings")
                    .font(.title.bold())
                    .fontDesign(.rounded)
                    .foregroundStyle(.white)
                    .background (
                        Text("Settings")
                            .font(.title.bold())
                            .fontDesign(.rounded)
                            .foregroundStyle(.gray)
                            .offset(y: 4)
                    )
                
                VStack{
                    
                }
            }
            
        }
    }
}

#Preview {
    SettingsView()
}
