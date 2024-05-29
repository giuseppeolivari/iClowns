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
    let modelContainer: ModelContainer
    
    init() {
        do {
            modelContainer = try ModelContainer(for: Collectible.self)
        } catch {
            fatalError("Could not initialize ModelContainer")
        }
    }
    
    var body: some Scene {
        WindowGroup {
            MapView()
        }.modelContainer(modelContainer)
    }
}
