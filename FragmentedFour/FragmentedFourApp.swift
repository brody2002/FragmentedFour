//
//  FragmentedFourApp.swift
//  FragmentedFour
//
//  Created by Brody on 11/26/24.
//
import SwiftUI
import SwiftData


@main
struct FragmentedFourApp: App {
    @Environment(\.modelContext) var modelContext

    var body: some Scene {
        WindowGroup {
            LevelView()
                .modelContainer(for: Level.self)
                
        }
    }
}
