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
    
    var body: some View {
        NavigationStack{
            Map(position: $cameraPosition, selection: $selectedTag) {
                UserAnnotation()
                ForEach(attractions) { attraction in
                    Marker("Attraction", systemImage: "figure.wave", coordinate: attraction.coordinate).tag(attraction.id.hashValue)
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














