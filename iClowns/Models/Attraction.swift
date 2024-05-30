//
//  Attraction.swift
//  WonderSeek
//
//  Created by Luigi Penza on 30/05/24.
//

import SwiftData
import CoreLocation

@Model class Attraction {
    var name: String
    var latitude: Double
    var longitude: Double
    
    var radius: CLLocationDistance
    
    var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    init(name: String, latitude: Double, longitude: Double, radius: CLLocationDistance = 0) {
        self.name = name
        self.latitude = latitude
        self.longitude = longitude
        self.radius = radius
    }
}
