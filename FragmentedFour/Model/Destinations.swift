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
        case selectLevel(animation: Namespace.ID)
        case levelDestination(level: Level, animation: Namespace.ID, comingFromFastTravel: Bool)
        case store
    }
}
