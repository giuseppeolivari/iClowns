//
//  iClownsApp.swift
//  iClowns
//
//  Created by Giuseppe Olivari on 13/05/24.
//

import SwiftUI
import SwiftData

@main
struct iClownsApp: App {
    let modelContainer: ModelContainer
    
    init() {
        do {
            modelContainer = try ModelContainer(for: Collectible.self)
            let modelContext = ModelContext(modelContainer)
            let collectibles = [
                Collectible(
                    title: "O’ Curniciell",
                    subtitle: "Il cornicello Napoletano",
                    image: "Stamp",
                    category: "Popular Beliefs",
                    latitude: 40.850077,
                    longitude: 14.257811,
                    curiosity: "Che belllo il cornicello lo sai è rosso bla bla bla bla porta fortuna, te lo devono regalare altrimenti super seccia e te lo devono attivare pungendoti la manella con la punta del corno. Bello eh? Che belllo il cornicello lo sai è rosso bla bla bla bla porta fortuna, te lo devono regalare altrimenti super seccia e"
                )
            ]
            
            // try modelContext.delete(model: Collectible.self)
            for _ in 0..<collectibles.count {
                //try await Task.sleep(for: .milliseconds(1))
                //modelContext.insert(collectible[i])
            }
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
