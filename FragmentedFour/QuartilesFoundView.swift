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
            
            HStack(spacing: 4 ){
                ForEach(0..<5){ i in
                    RoundedRectangle(cornerRadius: 4)
                        .fill(i < quartiles ? .white : .black.opacity(0.25))
                        .frame(width: 16, height: 16)
                }
            }
            
        }
    }
}

#Preview {
    QuartilesFoundView(quartiles: 3)
}
