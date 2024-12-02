//
//  testingView.swift
//  FragmentedFour
//
//  Created by Brody on 12/2/24.
//

import SwiftUI

struct testingView: View {
    @State var testBool = false
    var body: some View {
        VStack{
            Circle()
                .frame(width: 30, height: 30)
                .shakeEffect(
                                    trigger: testBool,
                                    distance: 10,
                                    animationDuration: 0.03,
                                    delayBetweenShakes: 0.01,
                                    initialDelay: 0.2
                                )
            Spacer()
                .frame(height: 20)
            
            Button(action:{testBool.toggle()}, label:{
                Text("Toggle \(testBool ? "off" : "on" )")
            })
        }
        
    }
}

#Preview {
    testingView()
}
