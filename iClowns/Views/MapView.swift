//
//  MapWithNotification.swift
//  iClowns
//
//  Created by Giuseppe Olivari on 15/05/24.
//

import SwiftUI
import MapKit
import UserNotifications

struct Attrazioni{
    var cordinata = CLLocationCoordinate2D()
    var raggio = CLLocationDistance()
    init(cordinata: CLLocationCoordinate2D, raggio: CLLocationDistance) {
       self.cordinata = cordinata
       self.raggio = raggio
     }
   
}

extension CLLocationCoordinate2D {
    static let attrazione11 = Attrazioni(cordinata: CLLocationCoordinate2D(latitude: 40.841447, longitude: 14.245233), raggio: 20.0) //murales maradona
    static let attrazione22 = Attrazioni(cordinata:CLLocationCoordinate2D(latitude: 40.858873, longitude: 14.238852), raggio: 20.0) // cimitero fontanelle
    static let attrazione33 = Attrazioni(cordinata:CLLocationCoordinate2D(latitude: 40.850077, longitude: 14.257811), raggio: 100.0) // san gregorio armeno
    static let attrazione44 = Attrazioni(cordinata:CLLocationCoordinate2D(latitude: 40.852447,  longitude: 14.258966), raggio: 15.0) //duomo san gennaro
    static let attrazione55 = Attrazioni(cordinata:CLLocationCoordinate2D(latitude: 40.851484,  longitude: 14.258777), raggio: 400.0) //via dei tribunali
    /* static let attrazione66 = Attrazioni(cordinata:CLLocationCoordinate2D(latitude: 41.0689236,  longitude: 14.6351510), raggio: 50.0) //test */
 
}



struct MapView: View {
    
    
    
    let manager = LocationManagerDelegate()
    
    @State private var cameraPosition: MapCameraPosition = .userLocation(fallback: .automatic)
    
    @State var selectedTag: Int?
    
    
    
    var body: some View {
        NavigationStack{
            Map(position: $cameraPosition, selection: $selectedTag) {
                
                UserAnnotation()
                
                
                Marker("Attraction", systemImage: "figure.wave", coordinate: .attrazione11.cordinata) //murales maradona
                    .tag(1)
                
                
                Marker("Attraction", systemImage: "figure.wave", coordinate: .attrazione22.cordinata) //cimitero fontanelle
                    .tag(2)
                Marker("Attraction", systemImage: "figure.wave", coordinate: .attrazione33.cordinata)
                    .tag(3)
                Marker("Attraction", systemImage: "figure.wave", coordinate: .attrazione44.cordinata) //duomo san gennaro
                    .tag(4)
                Marker("Attraction", systemImage: "figure.wave", coordinate: .attrazione55.cordinata)
                    .tag(6)
            }
            
            //.mapStyle(.standard(elevation: .realistic))
            .mapStyle(.standard(pointsOfInterest: .excludingAll))
            .rotation3DEffect(.degrees(90), axis: (x: 0, y: 0, z: 0))
            .mapControls{
                MapUserLocationButton()
                MapPitchToggle()
                MapCompass()
                MapScaleView()
                
            }
            
            
            
            
            
            NavigationLink(
                destination: LocationDetailView(selectedTag: $selectedTag),
                tag: selectedTag ?? -1,  // Use a default tag to avoid nil issues
                selection: $selectedTag,
                label: { EmptyView() }
            )
            
            
            
        }
        
    }
}


#Preview {
    MapView()
}














