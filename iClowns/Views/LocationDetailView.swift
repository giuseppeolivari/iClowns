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
    @Environment(\.modelContext) var modelContext
    
    @Query var collectibles: [Collectible]
    @Query var attractions: [Attraction]
    
    @Binding var selectedTag: Int?
    
    @State var attraction: Attraction?
    @StateObject var manager: LocationManagerDelegate = LocationManagerDelegate()
    
    @State var isUnlocking: Bool = false
    
    var body: some View {
        let filteredCollectibles = collectibles.filter { collectible in
            collectible.relatedAttraction.id.hashValue == selectedTag
        }
        
        if let collectible = filteredCollectibles.first {
            VStack{
                /* TOP OF THE VIEW */
                HStack {
                    Text(collectible.subtitle)
                        .bold()
                        .foregroundColor(Color.white)
                        .multilineTextAlignment(.leading)
                        .padding(.horizontal)
                    Spacer()
                }
                Rectangle()
                    .frame(width: UIScreen.main.bounds.width, height: 2.0)
                    .foregroundColor(.white)
                
                /* MID OF THE VIEW */
                HStack {
                    if !collectible.unlocked {
                        Card_Animation(isUnlocking: isUnlocking, collectible: collectible)
                            .onChange(of: isUnlocking, perform: { _ in
                                collectible.unlocked = true
                                //try modelContext.save()
                            })
                    } else {
                        Card_Animation(isUnlocking: collectible.unlocked, collectible: collectible)
                    }
                    /* RIGHT SIDE */
                    VStack(alignment: .leading) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 5)
                                .frame(width: UIScreen.main.bounds.width * 0.5 , height: UIScreen.main.bounds.height * 0.04)
                                .foregroundColor(Color(hex: "684298"))
                            HStack{
                                Text(" Category ")
                                    .fontWeight(.bold)
                                Spacer()
                            }
                        }
                        
                        Text(collectible.category)
                        
                        ZStack {
                            RoundedRectangle(cornerRadius: 5)
                                .frame(width: UIScreen.main.bounds.width * 0.5 , height: UIScreen.main.bounds.height * 0.04)
                                .foregroundColor(Color(hex: "684298"))
                            HStack{
                                Text(" Location ")
                                    .fontWeight(.bold)
                                Spacer()
                            }
                        }
                        /* ICON GROUP */
                        HStack{
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
                            
                            Text("\(collectible.relatedAttraction.name)")
                        }
                        
                    }
                }.padding()
                
                ZStack{
                    Rectangle()
                        .frame(width: UIScreen.main.bounds.width , height: UIScreen.main.bounds.height * 0.019)
                        .foregroundColor(Color(hex: "684298"))
                        .padding(.top)
                    
                    HStack{
                        ZStack{
                            RoundedRectangle(cornerRadius: 5)
                                .frame(width: UIScreen.main.bounds.width * 0.35, height: UIScreen.main.bounds.height * 0.035)
                                .foregroundColor(Color(hex: "684298"))
                            
                            Text("Curiosity")
                                .font(.title2)
                                .bold()
                        }
                        Spacer()
                    }
                }
                
                /* BOTTOM SIDE */
                VStack{
                    
                    
                    /* SCAN SIDE */
                    if !collectible.unlocked {
                        Spacer()
                        Text("SCAN TO FIND OUT!")
                            .font(.title)
                            .fontWeight(.black)
                            .padding()
                        
                        Spacer()
                        ZStack {
                            Button(action: {
                                print("Floating Button Click")
                            }, label: {
                                NavigationLink(destination: CameraView(isUnlocking: $isUnlocking, attraction: collectible.relatedAttraction)) {
                                    Image("Scan Button")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: UIScreen.main.bounds.width * 0.15 , height: UIScreen.main.bounds.height * 0.15)
                                        .padding(.top)
                                }
                            })
                            if (manager.isOnPosition(collectible: collectible)){
                                Button(action: {
                                    print("Floating Button Click")
                                }, label: {
                                    NavigationLink(destination: CameraView(isUnlocking: $isUnlocking, attraction: collectible.relatedAttraction)) {
                                        Image("Scan Button")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: UIScreen.main.bounds.width * 0.15 , height: UIScreen.main.bounds.height * 0.15)
                                            .padding(.top)
                                    }
                                })
                            }
                            
                        }.ignoresSafeArea()
                    } else {
                        ScrollView {
                            Text(collectible.curiosity)
                                .padding()
                        }.defaultScrollAnchor(.top)
                        
                        Spacer()
                    }
                }.navigationTitle(collectible.title)
            }
            .background(Color(hex: "1C1C1E"))
            
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
