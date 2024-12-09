//
//  SelectedTileView.swift
//  FragmentedFour
//
//  Created by Brody on 11/26/24.
//

import SwiftUI

struct SelectedTileView: View {
    var text:String
    @Binding var turnRed: Bool
    @Binding var turnGreen: Bool
    @State var mainColor: Color
    
    var body: some View {
        Text(text)
            .frame(minHeight: turnGreen ? 60: 44 , maxHeight: turnGreen ? 80: 64)
            .padding(.horizontal)
            .foregroundStyle(.white)
            .background(turnRed ? .red : turnGreen ? .green : mainColor)
            .clipShape(.rect(cornerRadius: 10))
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(turnRed ? .red.mix(with: .black, by: 0.25) : turnGreen ? .green.mix(with: .black, by: 0.25) : mainColor.mix(with: .black, by: 0.25))
                    .offset(y: 4)
            )
            .shakeEffect(
                trigger: turnRed,
                distance: 5,
                animationDuration: 0.05,
                initialDelay: 0.0
            )

        
    }
}

struct NoGrayOutButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .opacity(configuration.isPressed ? 1.0 : 1.0) // Optional visual feedback for pressing
    }
}

#Preview {
    SelectedTileView(text: "abc", turnRed: .constant(false), turnGreen: .constant(false), mainColor: AppColors.coreBlue)
}
