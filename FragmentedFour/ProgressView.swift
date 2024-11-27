//
//  ProgressView.swift
//  FragmentedFour
//
//  Created by Brody on 11/26/24.
//

import SwiftUI

struct MyProgressView: View {
    
    var backgroundColor: Color
    var foregroundColor: Color
    var progress: Double
    var total: Double
    
    var body: some View {
        Capsule()
            .fill(backgroundColor)
            .padding(1)
            .overlay(
                GeometryReader { proxy in
                    Capsule()
                        .fill(foregroundColor)
                        .frame(width: proxy.size.width * progress / total)
                
                },
                alignment: .leading
            )
        
    }
}

#Preview {
    MyProgressView(backgroundColor: .blue, foregroundColor: .white, progress: 0.5, total: 1)
}
