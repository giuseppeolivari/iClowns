//
//  Collectibles.swift
//  iClowns
//
//  Created by Luigi Penza on 13/05/24.
//

import SwiftData

@Model class Collectible {
    var title: String
    var subtitle: String
    var image: String
    var category: String
    var curiosity: String
    
    var relatedAttraction: Attraction

    var unlocked: Bool = false
    
    
    init(title: String, subtitle: String, image: String, category: String, attraction: Attraction, curiosity: String) {
        self.title = title
        self.subtitle = subtitle
        self.image = image
        self.category = category
        self.relatedAttraction = attraction
        self.curiosity = curiosity
    }
}
