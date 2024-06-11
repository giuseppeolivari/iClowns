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
                                Image(collectible.unlocked ? collectible.image : "retrofrankobolls")
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
                                Image(collectible.unlocked ? collectible.image : "retrofrankobolls")
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
                                Image(collectible.unlocked ? collectible.image : "retrofrankobolls")
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
