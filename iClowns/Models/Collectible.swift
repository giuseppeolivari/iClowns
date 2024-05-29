//
//  Collectibles.swift
//  iClowns
//
//  Created by Luigi Penza on 13/05/24.
//

import Foundation
import SwiftData

@Model class Collectible {
    var title: String
    var subtitle: String
    
    var image: String
    var category: String
    
    var latitude: Double
    var longitude: Double
    
    var curiosity: String
    
    var unlocked: Bool = false
    
    init(title: String, subtitle: String, image: String, category: String, latitude: Double, longitude: Double, curiosity: String) {
        self.title = title
        self.subtitle = subtitle
        self.image = image
        self.category = category
        self.latitude = latitude
        self.longitude = longitude
        self.curiosity = curiosity
    }
}
