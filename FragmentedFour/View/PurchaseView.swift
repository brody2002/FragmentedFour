//
//  PurchaseView.swift
//  FragmentedFour
//
//  Created by Brody on 12/5/24.
//

import SwiftUI

struct PurchaseView: View {
    var body: some View {
        ZStack{
            LinearGradient(
                gradient: Gradient(colors: [.pink, .indigo]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            Text("Buy for _ words?!?!?!")
                .foregroundColor(.white)
                .bold()
                .font(.system(size: 40))
            
        }
        .frame(maxWidth: .infinity, minHeight: 400, maxHeight: 400)
        .cornerRadius(10)
        
    }
}

#Preview {
    PurchaseView()
}
