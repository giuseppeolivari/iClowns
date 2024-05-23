//
//  Collectibles.swift
//  iClowns
//
//  Created by Luigi Penza on 13/05/24.
//

import Foundation
import SwiftData

@Model class Collectible {
    var name: String
    var info: String
    var image: String
    var unlocked: Bool
    var category: String
    var latitude: Double
    var longitude: Double
    
    init(name: String, info: String, image: String, unlocked: Bool, category: String, latitude: Double, longitude: Double) {
        self.name = name
        self.info = info
        self.image = image
        self.unlocked = unlocked
        self.category = category
        self.latitude = latitude
        self.longitude = longitude
    }
    
}
