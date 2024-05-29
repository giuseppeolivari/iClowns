//
//  ContentViwe.swift
//  iClowns
//
//  Created by Luigi Penza on 28/05/24.
//

import Foundation
import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var context
    @Query var collectibles: [Collectible]
    
    let corno = Collectible(
        title: "O’ Curniciell",
        subtitle: "Il cornicello Napoletano",
        image: "Stamp",
        category: "Popular Beliefs",
        latitude: 40.850077,
        longitude: 14.257811,
        curiosity: "Che belllo il cornicello lo sai è rosso bla bla bla bla porta fortuna, te lo devono regalare altrimenti super seccia e te lo devono attivare pungendoti la manella con la punta del corno. Bello eh? Che belllo il cornicello lo sai è rosso bla bla bla bla porta fortuna, te lo devono regalare altrimenti super seccia e"
    )
    
    var body: some View {
        List(collectibles) { collectible in
            Text(collectible.title)
                .swipeActions {
                    Button("Delete", systemImage: "trash", role: .destructive) {
                        context.delete(collectible)
                    }
                }
        }
        
        Button("Insert") {
            context.insert(corno)
        }
        
        Button("Delete all") {
            do {
                try context.delete(model: Collectible.self)
            } catch {
                print("Failed to delete all schools.")
            }
        }
    }
}
