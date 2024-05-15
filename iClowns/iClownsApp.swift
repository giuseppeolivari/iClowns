//
//  iClownsApp.swift
//  iClowns
//
//  Created by Giuseppe Olivari on 13/05/24.
//

import SwiftUI
import SwiftData

@main
struct iClownsApp: App {
    var body: some Scene {
        WindowGroup {
            CameraView()
        }.modelContainer(for: Collectible.self)
    }
}
