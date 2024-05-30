//
//  LocationDetailView.swift
//  iClowns
//
//  Created by Giuseppe Olivari on 23/05/24.
//

import SwiftUI
import MapKit
import SwiftData

struct LocationDetailView: View {
    @Query var collectibles: [Collectible]
    @Query var attractions: [Attraction]
    
    @Binding var selectedTag: Int?
    
    @State var attraction: Attraction?
    
    var body: some View {
        let filteredCollectibles = collectibles.filter { collectible in
            collectible.relatedAttraction.id.hashValue == selectedTag
        }
        
        if let collectible = filteredCollectibles.first {
            ZStack{
                Color(hex: "1C1C1E")
                    .ignoresSafeArea(edges: .all)
                
                GeometryReader { proxy in
                    /* TOP OF THE VIEW */
                    Group{
                        Text(collectible.title)
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(Color.white)
                            .position( x: proxy.size.width / 2.5 ,
                                       y: proxy.size.height / 15)
                        
                        Text(collectible.subtitle)
                            .font(.headline)
                            .foregroundColor(Color.white)
                            .position(x: proxy.size.width / 5 ,
                                      y: proxy.size.height / 8
                            )
                        
                        Rectangle()
                            .frame(width: 340.0, height: 2.0)
                            .foregroundColor(.white)
                            .position( x:proxy.size.width / 2 ,
                                       y:proxy.size.height / 6)
                    }
                    
                    /* MID OF THE VIEW */
                    Image(collectible.image)
                        .frame(width: 150.0, height: 250.0)
                        .position( x:proxy.size.width / 4 ,
                                   y:proxy.size.height / 2.55)
                        .foregroundColor(.white)
                    
                    /* RIGHT SIDE */
                    RoundedRectangle(cornerRadius: 5)
                        .frame(width: 200, height: 25.0)
                        .foregroundColor(Color(hex: "684298"))
                        .position( x: proxy.size.width / 1.3 ,
                                   y: proxy.size.height / 4)
                    
                    RoundedRectangle(cornerRadius: 5)
                        .frame(width: 200, height: 25.0)
                        .foregroundColor(Color(hex: "684298"))
                        .position( x: proxy.size.width / 1.3 ,
                                   y: proxy.size.height / 2.9)
                    
                    /* TEXT */
                    Text(" Category ")
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .position(x: proxy.size.width / 1.6,
                                  y: proxy.size.height / 4)
                    
                    Text(" Location ")
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .position(x: proxy.size.width / 1.6,
                                  y: proxy.size.height / 2.9)
                    
                    
                    /* TEXT PLACEHOLDER */
                    Text(collectible.category)
                        .foregroundColor(.white)
                        .position(x: proxy.size.width / 1.45,
                                  y: proxy.size.height / 3.4)
                    
                    Text("\(collectible.relatedAttraction.name)")
                        .foregroundColor(.white)
                        .position(x: proxy.size.width / 1.28,
                                  y: proxy.size.height / 2.59)
                    
                    /* ICON GROUP */
                    Group{
                        Button(action:{
                            for attraction in attractions {
                                if attraction.id.hashValue == selectedTag {
                                    self.attraction = attraction
                                }
                            }
                            
                            // Apple maps
                            if let url = URL(string: "http://maps.apple.com/?daddr=\(attraction!.latitude),\(attraction!.longitude)&dirflg=d") {
                                UIApplication.shared.open(url)
                            }
                            
                            // Google Maps
                            if let url = URL(string: "comgooglemaps://?daddr=\(attraction!.latitude),\(attraction!.longitude)&directionsmode=driving") {
                                UIApplication.shared.open(url)
                            }
                        },label:{
                            ZStack {
                                Circle()
                                    .frame(width: 30, height: 30)
                                    .foregroundColor(Color(hex: "EEDDF0"))
                                Image(systemName: "paperplane.fill")
                                    .foregroundColor(Color(hex: "684298"))
                            }
                        })
                    }
                    .position(x:proxy.size.width / 1.8, y:proxy.size.height / 2.58)
                    
                    /* BOTTOM SIDE */
                    Group{
                        RoundedRectangle(cornerRadius: 5)
                            .frame(width: 150.0, height: 35.0)
                            .foregroundColor(Color(hex: "684298"))
                            .position( x: proxy.size.width / 5.5 ,
                                       y: proxy.size.height / 1.5)
                        
                        Rectangle()
                            .frame(width: 400.0, height: 7)
                            .foregroundColor(Color(hex: "684298"))
                            .position( x: proxy.size.width / 2 ,
                                       y: proxy.size.height / 1.45)
                        
                        Text("Curiosity")
                            .font(.title2)
                            .bold()
                            .foregroundColor(.white)
                            .position( x: proxy.size.width / 6.5 ,
                                       y: proxy.size.height / 1.5)
                        
                    }.position( x: proxy.size.height / 4 ,
                                y: proxy.size.width / 1.14)
                    
                    /* SCAN SIDE */
                    Image("Polygon 2")
                }
            }
        } else {
            Text("No collectible found!")
        }
    }
}

extension Color {
    init(hex: String) {
        var cleanHexCode = hex.trimmingCharacters(in:.whitespacesAndNewlines)
        cleanHexCode = cleanHexCode.replacingOccurrences(of: "#", with: "")
        
        var rgb: UInt64 = 0
        
        Scanner(string: cleanHexCode).scanHexInt64(&rgb)
        
        let redValue = Double((rgb >> 16) & 0xFF) / 255.0
        let greenValue = Double((rgb >> 8) & 0xFF) / 255.0
        let blueValue = Double(rgb & 0xFF) / 255.0
        self.init(red: redValue, green: greenValue, blue: blueValue)
    }
}
