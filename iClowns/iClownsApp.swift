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
            let configuration = ModelConfiguration(isStoredInMemoryOnly: true)
            modelContainer = try ModelContainer(for: Collectible.self, Attraction.self, configurations: configuration)
            let modelContext = ModelContext(modelContainer)
            
            //TODO: TOGLI QUESTO
            try modelContext.delete(model: Collectible.self)
            try modelContext.delete(model: Attraction.self)
            
            let attractions = [
                Attraction(name: "Via Emanuele de Deo, 46", latitude: 40.841447, longitude: 14.245233, radius: 20.0),
                Attraction(name: "Cimitero Fontanelle", latitude: 40.858873, longitude: 14.238852, radius: 20.0),
                Attraction(name: "Via S. Gregorio Armeno, 14-52",latitude: 40.850077, longitude: 14.257811, radius: 100.0),
                Attraction(name: "Via Duomo, 147 ",latitude: 40.852447,  longitude: 14.258966, radius: 15.0),
                Attraction(name: "Via dei Tribunali",latitude: 40.851484,  longitude: 14.258777, radius: 400.0)
            ]
            let collectibles = [
                Collectible(
                    title: "Maradona",
                    subtitle: "Maradona",
                    image: "Stamp",
                    category: "Popular Beliefs",
                    attraction: attractions[0],
                    curiosity: "Che belllo il cornicello lo sai è rosso bla bla bla bla porta fortuna, te lo devono regalare altrimenti super seccia e te lo devono attivare pungendoti la manella con la punta del corno. Bello eh? Che belllo il cornicello lo sai è rosso bla bla bla bla porta fortuna, te lo devono regalare altrimenti super seccia e"
                ),
                Collectible(
                    title: "Cimitero Delle Fontanelle",
                    subtitle: "Il cornicello Napoletano",
                    image: "Stamp",
                    category: "Entertainment",
                    attraction: attractions[1],
                    curiosity: "Che belllo il cornicello lo sai è rosso bla bla bla bla porta fortuna, te lo devono regalare altrimenti super seccia e te lo devono attivare pungendoti la manella con la punta del corno. Bello eh? Che belllo il cornicello lo sai è rosso bla bla bla bla porta fortuna, te lo devono regalare altrimenti super seccia e"
                ),
                Collectible(
                    title: "‘O Presep’",
                    subtitle: "The Creche",
                    image: "Stamp",
                    category: "Traditions",
                    attraction: attractions[2],
                    curiosity: "Che belllo il cornicello lo sai è rosso bla bla bla bla porta fortuna, te lo devono regalare altrimenti super seccia e te lo devono attivare pungendoti la manella con la punta del corno. Bello eh? Che belllo il cornicello lo sai è rosso bla bla bla bla porta fortuna, te lo devono regalare altrimenti super seccia e"
                ),
                Collectible(
                    title: "San Gennà",
                    subtitle: "Saint John",
                    image: "Stamp",
                    category: "Popular Beliefs",
                    attraction: attractions[3],
                    curiosity: "Three times a year, on solemn dates, San Gennaro renews his bond with Naples, and his blood is displayed in front of thousands of citizens and faithful who hope that it will liquefy. The cult of San Gennaro has always been deeply rooted in Neapolitan culture. The Neapolitans have a relationship peer to peer with San Gennaro, expressing it through constant, familiar dialogue. San Gennaro, pensaci tu! is an invocation repeated in the face of personal worries and collective fears ."
                ),
                Collectible(
                    title: "Via dei Tribunali",
                    subtitle: "Il cornicello Napoletano",
                    image: "Stamp",
                    category: "Popular Beliefs",
                    attraction: attractions[4],
                    curiosity: "Che belllo il cornicello lo sai è rosso bla bla bla bla porta fortuna, te lo devono regalare altrimenti super seccia e te lo devono attivare pungendoti la manella con la punta del corno. Bello eh? Che belllo il cornicello lo sai è rosso bla bla bla bla porta fortuna, te lo devono regalare altrimenti super seccia e"
                ),
            ]
            
            // Checking number of attractions
            let attractionDescriptor = FetchDescriptor<Attraction>()
            var attractionsCount = 0
            try modelContext.enumerate(attractionDescriptor, block: { attraction in
                attractionsCount += 1
            })
            // Checking number of collectibles
            let collectiblesDescriptor = FetchDescriptor<Collectible>()
            var collectiblesCount = 0
            try modelContext.enumerate(collectiblesDescriptor, block: { collectible in
                collectiblesCount += 1
            })
#if DEBUG
            print("Attractions in the database: ", attractionsCount)
            print("Collectibles in the database: ", collectiblesCount)
#endif
            if attractionsCount != attractions.count {
                for i in 0..<attractions.count {
                    modelContext.insert(attractions[i])
                }
            }
            
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
