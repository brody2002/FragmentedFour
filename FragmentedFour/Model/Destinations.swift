//
//  Destinations.swift
//  FragmentedFour
//
//  Created by Brody on 12/6/24.
//

import Foundation
import SwiftUI

struct DestinationStruct {
    
    enum Destination: Hashable{
        case selectLevel
        case levelDestination(level: Level, comingFromFastTravel: Bool)
        case store
        case tutorial
    }
}
