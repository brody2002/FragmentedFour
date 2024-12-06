//
//  QuartilesFoundView.swift
//  FragmentedFour
//
//  Created by Brody on 11/26/24.
//

import SwiftUI

struct QuartilesFoundView: View {
    var quartiles: Int
    var body: some View {
        VStack(alignment: .leading, spacing: 8){
            Text("Quartiles")
                .font(.body.bold())
                .foregroundStyle(.white)
                .background(
                    Text("Quartiles")
                        .font(.body.bold())
                        .offset(y: 1)
                        .foregroundColor(.gray)
                )
            
            HStack(spacing: 4 ){
                ForEach(0..<5){ i in
                    RoundedRectangle(cornerRadius: 4)
                        .fill(i < quartiles ? .white : .black.opacity(0.25))
                        .frame(width: 16, height: 16)
                        .background(
                            RoundedRectangle(cornerRadius: 4)
                                .fill(i < quartiles ? .gray : .white.opacity(0.25))
                                .frame(width: 16, height: 16)
                                .offset(y: 1)
                        )
                }
            }
            
        }
    }
}

#Preview {
    ZStack{
        Color.red
        QuartilesFoundView(quartiles: 3)
    }
    
}
