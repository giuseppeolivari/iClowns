//
//  iClownsApp.swift
//  iClowns
//
//  Created by Giuseppe Olivari on 13/05/24.
//

import SwiftUI
import SwiftData

//TODO: Richiesta per posizione in background 

@main
struct iClownsApp: App {    
    var body: some Scene {
        WindowGroup {
            CameraView()
        }.modelContainer(for: Collectible.self)
    }
}
