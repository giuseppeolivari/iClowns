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
    @Binding var selectedTag: Int?
    
    static var title: String = "O’ Curniciell"
    /*@Query(filter: #Predicate<Collectible> { collectible in
        collectible.title == title
    }) var collectibles: [Collectible]*/
    @Query var collectibles: [Collectible]
    
    var body: some View {
        ForEach(collectibles) { collectible in
            if collectible.title == LocationDetailView.title {
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
                                .position( x: proxy.size.width / 3.3 ,
                                           y: proxy.size.height / 150)
                               
                            
                            Text(collectible.subtitle)
                                .font(.headline)
                                .foregroundColor(Color.white)
                                .position(x: proxy.size.width / 3.3 ,
                                          y: proxy.size.height / 15
                                )
                            
                            Rectangle()
                                .frame(width: 340.0, height: 2.0)
                                .foregroundColor(.white)
                                .position( x:proxy.size.width / 2 ,
                                           y:proxy.size.height / 10)
                        }
                        
                        /* MID OF THE VIEW */
                        Image(collectible.image)
                            .frame(width: 150.0, height: 250.0)
                            .position( x:proxy.size.width / 4 ,
                                       y:proxy.size.height / 3)
                            .foregroundColor(.white)
                        
                        /* RIGHT SIDE */
                        RoundedRectangle(cornerRadius: 5)
                            .frame(width: 200, height: 25.0)
                            .foregroundColor(Color(hex: "684298"))
                            .position( x: proxy.size.width / 1.3 ,
                                       y: proxy.size.height / 5)
                        
                        RoundedRectangle(cornerRadius: 5)
                            .frame(width: 200, height: 25.0)
                            .foregroundColor(Color(hex: "684298"))
                            .position( x: proxy.size.width / 1.3 ,
                                       y: proxy.size.height / 3)
                        
                        /* TEXT */
                        Text(" Category ")
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .position(x: proxy.size.width / 1.6,
                                      y: proxy.size.height / 5)
                        
                        Text(" Location ")
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .position(x: proxy.size.width / 1.6,
                                      y: proxy.size.height / 3)
                        
                        
                        /* TEXT PLACEHOLDER */
                        Text(collectible.category)
                            .foregroundColor(.white)
                            .position(x: proxy.size.width / 1.5,
                                      y: proxy.size.height / 4)
                        
                        Text("\(collectible.latitude + collectible.longitude)")
                            .foregroundColor(.white)
                            .position(x: proxy.size.width / 1.28,
                                      y: proxy.size.height / 2.59)
                        
                        /* ICON GROUP */
                        Button(action:{
                            openMap(selectedTag: $selectedTag.wrappedValue)
                        },label:{
                          
                                ZStack{
                                    Circle()
                                        .frame(width: 30, height: 30)
                                        .foregroundColor(Color(hex: "EEDDF0"))
                                    Image(systemName: "paperplane.fill")
                                        .foregroundColor(Color(hex: "684298"))
                                }
                               .position(x:proxy.size.width / 1.8 ,
                                       y:proxy.size.height / 2.58)
                            
                        })
                        
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
                            
                            Text("Lorem ipSDFDZSGVJSHDFJHGSZDHFBAJHSEBFJADGSZBEFJHABEWHRFGVJS<EKHFJYARWGRUFYHJASBEJFYGTAWEFHAWEYJRFGAWHFBhytejgfdbwjeyGFDJHAVRFGHYEWAJGBHKJ-AAAAAAADAFAFFAFAFAFFAaaaaaaaaaaaaaaaaaaaaa")
                                .fontWeight(.bold)
                                .foregroundColor(Color.white)
                                .frame(width: 350, height: 250)
                                .position( x: proxy.size.width / 2 ,
                                           y: proxy.size.height / 1.2)
                                
                            
                        }.position( x: proxy.size.height / 3.5 ,
                                    y: proxy.size.width / 1.5   )
                        
                        /* SCAN SIDE */
                        Image("Polygon 2")
                            .position( x: proxy.size.width / 2 ,
                                       y: proxy.size.height / 1.04)
                        Button(action: {
                            print("Floating Button Click")
                        }, label: {
                            NavigationLink(destination: CameraView()) {
                                Image("Scan Button")
                                    .frame(width: 50 , height: 50)
                            }
                        })
                        .position( x: proxy.size.width / 2 ,
                                   y: proxy.size.height / 1.04)
                    }
                }
            } else {
                Text("No collectible found!")
            }
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

func openMap(selectedTag: Int?) {
    let coordinate: CLLocationCoordinate2D
    switch selectedTag {
    case 1:
        coordinate = .attrazione11.cordinata
    case 2:
        coordinate = .attrazione22.cordinata
    case 3:
        coordinate = .attrazione33.cordinata
    case 4:
        coordinate = .attrazione44.cordinata
    case 6:
        coordinate = .attrazione55.cordinata
        
    default:
        return
    }
    
    // Apple Maps
    if let url = URL(string: "http://maps.apple.com/?daddr=\(coordinate.latitude),\(coordinate.longitude)&dirflg=d") {
        UIApplication.shared.open(url)
    }
    
    // Google Maps
    if let url = URL(string: "comgooglemaps://?daddr=\(coordinate.latitude),\(coordinate.longitude)&directionsmode=driving") {
        UIApplication.shared.open(url)
    }
}

