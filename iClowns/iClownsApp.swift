//
//  iClownsApp.swift
//  iClowns
//
//  Created by Giuseppe Olivari on 13/05/24.
//

import SwiftUI
import SwiftData

//TODO: Richiesta per posizione in background

@main
struct iClownsApp: App {
    @Query var collectibles: [Collectible]
    var body: some Scene {
        WindowGroup {
            ContentView()
        }.modelContainer(for: Collectible.self)
    }
}
