//
//  Customzoom.swift
//  FragmentedFour
//
//  Created by Brody on 12/11/24.
//

import NavigationTransition
import SwiftUI

extension AnyNavigationTransition {
    static var customZoom: Self {
        .init(CustomZoom())
    }
}

struct CustomZoom: NavigationTransitionProtocol {
    var body: some NavigationTransitionProtocol {
        MirrorPush {
            Scale(0.5)
            OnInsertion {
                ZPosition(1)
                Opacity()
            }
        }
    }
}


