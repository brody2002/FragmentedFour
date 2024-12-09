//
//  GemView.swift
//  FragmentedFour
//
//  Created by Brody on 12/9/24.
//

import SwiftUI

struct MoneyView: View {
    var body: some View {
        
        Image("Money")
            .resizable()
            .frame(width: 70, height: 70)
            .overlay(
                ZStack{
                    Image("Money")
                        .resizable()
                        .renderingMode(.template)
                        .foregroundStyle(AppColors.coreBlue.opacity(0.8))
                    Text("Fr")
                        .foregroundStyle(Color.black)
                        .font(.system(size: 20).bold())
                }
            )
            
            
    }
}

#Preview {
    MoneyView()
}
