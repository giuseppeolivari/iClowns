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
            
            let descriptor = FetchDescriptor<Collectible>()
            var collectiblesCount = 0
            try modelContext.enumerate(descriptor, block: { collectible in
                collectiblesCount += 1
            })
            #if DEBUG
            print("Collectibles in the database: ", collectiblesCount)
            #endif
            if collectiblesCount != collectibles.count {
                for i in 0..<collectibles.count {
                    modelContext.insert(collectibles[i])
                }
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
