//
//  PackPile View.swift
//  FragmentedFour
//
//  Created by Brody on 12/9/24.
//

import SwiftUI

struct individualCard: View {
    @State var name: String?
    var body: some View{
        ZStack{
            RoundedRectangle(cornerRadius: 10)
                .fill(AppColors.coreBlue)
                .background(
                    ZStack{
                        RoundedRectangle(cornerRadius: 10)
                            .offset(y: 6)
                            .fill(.gray)
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(style: StrokeStyle(lineWidth: 4))
                            .fill(AppColors.darkBlue)
                    }
                )
            if let label = name {
                VStack{
                    Text("LVL")
                        .foregroundStyle(.black)
                        .bold()
                    Text("\(label)")
                        .foregroundStyle(.black)
                        .bold()
                    
                }
            }
        }
        .frame(width: 70, height: 90)
        .fontDesign(.rounded)
        
        
    }
        
}

struct PackPile_View: View {
    var name: String
    var body: some View {
        ZStack{
            individualCard()
                .rotationEffect(Angle(degrees: 20))
                .offset(x: 15, y: -20)
            individualCard()
                .rotationEffect(Angle(degrees: 10))
                .offset(x: 10, y: -15)
            individualCard()
                .rotationEffect(Angle(degrees: 0))
                .offset(x: 5, y: -10)
            individualCard(name: name)
                .rotationEffect(Angle(degrees: -10))
        }
    }
}

#Preview {
    PackPile_View(name: "16-20")
}
