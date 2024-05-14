//
//  Maptest.swift
//  provaSwift
//
//  Created by Giuseppe Olivari on 10/05/24.
//

import SwiftUI
import MapKit

extension CLLocationCoordinate2D{
    static let attrazione = CLLocationCoordinate2D(latitude: 40.849400, longitude: 14.258200)
}

struct MapView: View {
    var body: some View {
        Map{
            Marker("Attrazione", systemImage: "figure.wave", coordinate: .attrazione)
        }.mapStyle(.standard(elevation: .realistic))
            .rotation3DEffect(.degrees(90), axis: (x: 0, y: 0, z: 0))
        
        
    }
}

#Preview {
    MapView()
}
