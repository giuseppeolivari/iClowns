//
//  MapWithNotification.swift
//  iClowns
//
//  Created by Giuseppe Olivari on 15/05/24.
//

import SwiftUI
import MapKit
import UserNotifications
import SwiftData

struct MapView: View {
    @State private var cameraPosition: MapCameraPosition = .userLocation(fallback: .automatic)
    @State var selectedTag: Int?
    
    @Query var attractions: [Attraction]
    
    let manager = LocationManagerDelegate()
    
    //serve solo per quando apri l'app così parte su napoli
    var napoli: CLLocationCoordinate2D{
        CLLocationCoordinate2D(
            latitude: 40.85245,
            longitude: 14.255862
        )
    }
    
    var body: some View {
        GeometryReader{ proxy in
            NavigationStack{
                ZStack {
                    Map(initialPosition: .region(MKCoordinateRegion(center: napoli, span:(MKCoordinateSpan(latitudeDelta: 0.09, longitudeDelta: 0.03)))), selection: $selectedTag) {
                        UserAnnotation()
                        ForEach(attractions) { attraction in
                            Marker("Attraction", systemImage: "circle", coordinate: attraction.coordinate).tag(attraction.id.hashValue)
                                .tint(Color(red: 0.902, green: 0.755, blue: 0.393))
                        }
                    }
                    .mapStyle(.standard(pointsOfInterest: .excludingAll))
                    .rotation3DEffect(.degrees(90), axis: (x: 0, y: 0, z: 0))
                    .mapControls{
                        MapUserLocationButton()
                        MapPitchToggle()
                        MapCompass()
                        MapScaleView()
                    }
                    
                    NavigationLink(
                        destination: LocationDetailView(selectedTag: $selectedTag, manager: manager),
                        tag: selectedTag ?? -1,  // Use a default tag to avoid nil issues
                        selection: $selectedTag,
                        label: { EmptyView() }
                    )
                    //deve andare nella view dei collectible
                    NavigationLink(destination: CollectibleView()) {
                        Image("bottone")
                            .resizable()
                            .frame(width: 44, height: 44)
                            .cornerRadius(7)
                    }.position(x: proxy.size.width / 1.25 ,
                               y: proxy.size.height / 29)
                }
            }
        }
    }
}


#Preview {
    MapView()
}
