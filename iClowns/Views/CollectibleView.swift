//
//  CollectibleView.swift
//  WonderSeek
//
//  Created by Luigi Penza on 05/06/24.
//

import SwiftUI
import SwiftData

struct CollectibleView: View {
    @Query var collectibles : [Collectible]

  
    var body: some View {
        
        let popularBeliefs = collectibles.filter{ collectible in
            collectible.category == "Popular Beliefs"
        }
        let entertainment = collectibles.filter{ collectible in
            collectible.category == "Entertainment"
        }
        let traditionsㅤㅤㅤ = collectibles.filter{ collectible in
            collectible.category == "Traditions"
        }
        
        NavigationStack{
            ZStack {
                Color(hex: "1C1C1E")
                    .ignoresSafeArea()
                
                VStack() {
                    /*   FIRST GROUP   */
                    ZStack {
                        Image("headerBackground")
                            .resizable()
                            .frame(width: 400, height: 30)
                        
                        Text("Popular Beliefs")
                            .font(.title3)
                            .fontWeight(.bold)
                            .frame(width: 158 , height: 31, alignment: .leading)
                            .foregroundColor(.white)
                            .padding(.trailing, 220)
                        
                        Text("Stamps Obtained " + "\(countUnlocked(collectibles: popularBeliefs))" + " / " + "\(popularBeliefs.count)")
                            .foregroundStyle(Color.white)
                            .font(.footnote)
                            .padding(.leading, 240)
                    }
                    .padding(.vertical, 20)
                    
                    ScrollView(.horizontal) {
                        HStack {
                            ForEach(popularBeliefs) { collectible in
                                Image(collectible.unlocked ? collectible.image : "Stamp 2")
                                    .resizable()
                                    .frame(width:85, height: 121)
                            }
                        }
                    }
                    
                    /*      SECOND GROUP      */
                    ZStack {
                        Image("headerBackground")
                            .resizable()
                            .frame(width: 400, height: 30)
                        
                        Text("Entertainment")
                            .font(.title3)
                            .fontWeight(.bold)
                            .frame(width: 158 , height: 31, alignment: .leading)
                            .foregroundColor(.white)
                            .padding(.trailing, 220)
                        
                        Text("Stamps Obtained " + "\(countUnlocked(collectibles: entertainment))" + " / " + "\(entertainment.count)")
                            .foregroundStyle(Color.white)
                            .font(.footnote)
                            .padding(.leading, 240)
                    }
                    .padding(.vertical, 20)
                    
                    ScrollView(.horizontal) {
                        HStack {
                            ForEach(entertainment) { collectible in
                                Image(collectible.unlocked ? collectible.image : "Stamp 2")
                                    .resizable()
                            }.frame(width:85, height: 121)
                        }
                    }
                    
                    /*      THIRD GROUP      */
                    ZStack {
                        Image("headerBackground")
                            .resizable()
                            .frame(width: 400, height: 30)
                        
                        
                        Text("Traditions")
                            .font(.title3)
                            .fontWeight(.bold)
                            .frame(width: 158 , height: 31, alignment: .leading)
                            .foregroundColor(.white)
                            .padding(.trailing, 220)
                        
                        Text("Stamps Obtained " + "\(countUnlocked(collectibles: traditionsㅤㅤㅤ))" + " / " + "\(traditionsㅤㅤㅤ.count)")
                            .foregroundStyle(Color.white)
                            .font(.footnote)
                            .padding(.leading, 240)
                    }
                    .padding(.vertical, 20)
                    
                    ScrollView(.horizontal) {
                        HStack {
                            ForEach(traditionsㅤㅤㅤ) { collectible in
                                Image(collectible.unlocked ? collectible.image : "Stamp 2")
                                    .resizable()
                                    .foregroundStyle(.white)
                            }.frame(width:85, height: 121)
                        }
                    }
                }
            }
        }
        .navigationTitle("Collectible Stamps")
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Collectible Stamps")
                    .foregroundColor(Color(hex:"8862F7"))
            }
        }
    }
    
    func countUnlocked(collectibles: [Collectible]) -> Int{
        var count: Int = 0
        
        for collectible in collectibles {
            if collectible.unlocked {
                count += 1
            }
        }
        
        return count
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Collectible.self, Attraction.self, configurations: config)
    
    let attraction = Attraction(name: "murales maradona", latitude: 40.841447, longitude: 14.245233, radius: 20.0)
    
    let collectibleA = Collectible(
        title: "O’ Curniciell",
        subtitle: "Il cornicello Napoletano",
        image: "Stamp",
        category: "Popular Beliefs",
        attraction: attraction,
        curiosity: "Che belllo il cornicello lo sai è rosso bla bla bla bla porta fortuna, te lo devono regalare altrimenti super seccia e te lo devono attivare pungendoti la manella con la punta del corno. Bello eh? Che belllo il cornicello lo sai è rosso bla bla bla bla porta fortuna, te lo devono regalare altrimenti super seccia e"
    )
    let collectibleAAAAAA = Collectible(
        title: "O’ Curniciell",
        subtitle: "Il cornicello Napoletano",
        image: "Stamp",
        category: "Popular Beliefs",
        attraction: attraction,
        curiosity: "Che belllo il cornicello lo sai è rosso bla bla bla bla porta fortuna, te lo devono regalare altrimenti super seccia e te lo devono attivare pungendoti la manella con la punta del corno. Bello eh? Che belllo il cornicello lo sai è rosso bla bla bla bla porta fortuna, te lo devono regalare altrimenti super seccia e"
    )
    let collectibleAA = Collectible(
        title: "O’ Curniciell",
        subtitle: "Il cornicello Napoletano",
        image: "Stamp",
        category: "Popular Beliefs",
        attraction: attraction,
        curiosity: "Che belllo il cornicello lo sai è rosso bla bla bla bla porta fortuna, te lo devono regalare altrimenti super seccia e te lo devono attivare pungendoti la manella con la punta del corno. Bello eh? Che belllo il cornicello lo sai è rosso bla bla bla bla porta fortuna, te lo devono regalare altrimenti super seccia e"
    )
    let collectibleAAA = Collectible(
        title: "O’ Curniciell",
        subtitle: "Il cornicello Napoletano",
        image: "Stamp",
        category: "Popular Beliefs",
        attraction: attraction,
        curiosity: "Che belllo il cornicello lo sai è rosso bla bla bla bla porta fortuna, te lo devono regalare altrimenti super seccia e te lo devono attivare pungendoti la manella con la punta del corno. Bello eh? Che belllo il cornicello lo sai è rosso bla bla bla bla porta fortuna, te lo devono regalare altrimenti super seccia e"
    )
    
    let collectibleAAAA = Collectible(
        title: "O’ Curniciell",
        subtitle: "Il cornicello Napoletano",
        image: "Stamp",
        category: "Popular Beliefs",
        attraction: attraction,
        curiosity: "Che belllo il cornicello lo sai è rosso bla bla bla bla porta fortuna, te lo devono regalare altrimenti super seccia e te lo devono attivare pungendoti la manella con la punta del corno. Bello eh? Che belllo il cornicello lo sai è rosso bla bla bla bla porta fortuna, te lo devono regalare altrimenti super seccia e"
    )
    let collectibleB = Collectible(
        title: "O’ Curniciell",
        subtitle: "Il cornicello Napoletano",
        image: "Stamp",
        category: "Entertainment",
        attraction: attraction,
        curiosity: "Che belllo il cornicello lo sai è rosso bla bla bla bla porta fortuna, te lo devono regalare altrimenti super seccia e te lo devono attivare pungendoti la manella con la punta del corno. Bello eh? Che belllo il cornicello lo sai è rosso bla bla bla bla porta fortuna, te lo devono regalare altrimenti super seccia e"
    )
    let collectibleC = Collectible(
        title: "O’ Curniciell",
        subtitle: "Il cornicello Napoletano",
        image: "Stamp",
        category: "Traditions",
        attraction: attraction,
        curiosity: "Che belllo il cornicello lo sai è rosso bla bla bla bla porta fortuna, te lo devono regalare altrimenti super seccia e te lo devono attivare pungendoti la manella con la punta del corno. Bello eh? Che belllo il cornicello lo sai è rosso bla bla bla bla porta fortuna, te lo devono regalare altrimenti super seccia e"
    )
    
    container.mainContext.insert(attraction)
    container.mainContext.insert(collectibleA)
    container.mainContext.insert(collectibleAA)
    container.mainContext.insert(collectibleAAA)
    container.mainContext.insert(collectibleAAAA)
    container.mainContext.insert(collectibleAAAAAA)
    container.mainContext.insert(collectibleB)
    container.mainContext.insert(collectibleC)
    
    return CollectibleView()
        .modelContainer(container)
}
