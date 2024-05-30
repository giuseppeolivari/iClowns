//
//  LocationManagerDelegate.swift
//  iClowns
//
//  Created by Giuseppe Olivari on 22/05/24.
//


//versione con background
import Foundation
import CoreLocation
import UserNotifications
import SwiftData

class LocationManagerDelegate: NSObject, ObservableObject, CLLocationManagerDelegate {
    let container = try! ModelContainer(for: Collectible.self, Attraction.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
    var attractions: [Attraction] = []
    
    let geofenceRadius = 50.0
    let manager: CLLocationManager
    
    override init() {
        self.manager = CLLocationManager()
        super.init()
        self.manager.delegate = self
        self.manager.requestAlwaysAuthorization() // Richiedi autorizzazione  e scegli Always
        setupGeofences(geofenceRadius: geofenceRadius)
        requestNotificationPermission()
    }
    
    private func setupGeofences(geofenceRadius : CLLocationDistance) {
        let modelContext = ModelContext(container)
        let descriptor = FetchDescriptor<Attraction>()
        try! modelContext.enumerate(descriptor, block: { attraction in
            attractions.append(attraction)
        })
        
        for attraction in attractions {
            let region = CLCircularRegion(
                center: attraction.coordinate,
                radius: CLLocationDistance(attraction.radius),
                identifier: "\(attraction.latitude),\(attraction.longitude)"
            )
            region.notifyOnEntry = true
            manager.startMonitoring(for: region)
            print("Started monitoring region: \(region.identifier)")
        }
    }
    
    private func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                print("Notification permission error: \(error.localizedDescription)")
            } else {
                print("Notification permission granted: \(granted)")
            }
        }
    }
    
    private func sendNotification(for region: CLRegion) {
        print("notifica")
        let content = UNMutableNotificationContent()
        content.title = "Sei vicino a un'attrazione!"
        content.body = NSString.localizedUserNotificationString(forKey: "Hello_message_body", arguments: nil)
        content.sound = UNNotificationSound.default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(identifier: region.identifier, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Notification error: \(error.localizedDescription)")
            } else {
                print("Notification scheduled for region: \(region.identifier)")
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        if region is CLCircularRegion {
            print("Did enter region: \(region.identifier)")
            //forse qui aggiungo variabile per ragazzi!!!!!
            sendNotification(for: region)
        } else {
            print("Entered region but not a circular region: \(region.identifier)")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, monitoringDidFailFor region: CLRegion?, withError error: Error) {
        if let region = region {
            print("Monitoring failed for region with identifier: \(region.identifier)")
        }
        print("Monitoring failed with error: \(error.localizedDescription)")
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location manager failed with error: \(error.localizedDescription)")
    }
}


















