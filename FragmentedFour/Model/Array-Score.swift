//
//  Array-Score.swift
//  FragmentedFour
//
//  Created by Brody on 11/26/24.
//

import Foundation


extension Array{
    var score: Int{
        Int(pow(2, Double(count - 1)))
    }
}
