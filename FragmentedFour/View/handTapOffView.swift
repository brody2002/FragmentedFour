//
//  handTapOffView.swift
//  FragmentedFour
//
//  Created by Brody on 12/13/24.
//

import SwiftUI

struct handTapOffView: View {
    var isBackgroundView: Bool
    var isHomeScreen: Bool
    var body: some View {
        ZStack{
            Image(systemName: "hand.tap.fill")
                .resizable()
                
            Capsule()
                .frame(width: isHomeScreen ? 4 : 2, height: isHomeScreen ? 40: 20)
                .rotationEffect(.degrees(30))
                .background(
                    ZStack{
                        if isHomeScreen {
                            Capsule()
                                .frame(width: isHomeScreen ? 4 : 2, height: isHomeScreen ? 40: 20)
                                .foregroundStyle(.gray)
                                .rotationEffect(.degrees(30))
                                .offset(y: 3)
                        }
                    }
                )
        }
        .foregroundStyle(isBackgroundView ? .gray : .white)
        .frame(width: isHomeScreen ? 40 : 17, height: isHomeScreen ? 40: 17)
        
    }
}

#Preview {
    ZStack{
        AppColors.coreBlue
        handTapOffView(isBackgroundView: false, isHomeScreen: true)
    }
    
}
