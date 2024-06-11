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
        self.manager.desiredAccuracy = kCLLocationAccuracyBest
        self.manager.startUpdatingLocation()
        setupGeofences(geofenceRadius: geofenceRadius)
        requestNotificationPermission()
    }
    
    @Published var currentLocation: CLLocationCoordinate2D?
    
    
    public func stopUpdatingLocation() {
        manager.stopUpdatingLocation()
    }
    
    public func getCurrentLocation() -> CLLocationCoordinate2D? {
        return currentLocation
    }
    
    public func getLat() -> Double{
        return currentLocation?.latitude ?? 0.0
    }
    
    public func getLon() -> Double{
        return currentLocation?.longitude ?? 0.0
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
        content.title = "WonderSeek"
        content.body = NSString.localizedUserNotificationString(forKey: "There's something interesting nearby!", arguments: nil)
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
    
    func haversineDistance(lat1: Double, lon1: Double, lat2: Double, lon2: Double) -> Double {
        let radius: Double = 6371000.0 // Earth's radius in kilometers
        
        // Convert degrees to radians
        let lat1Rad = lat1 * .pi / 180
        let lon1Rad = lon1 * .pi / 180
        let lat2Rad = lat2 * .pi / 180
        let lon2Rad = lon2 * .pi / 180
        
        // Calculate differences
        let dLat = lat2Rad - lat1Rad
        let dLon = lon2Rad - lon1Rad
        
        // Apply Haversine formula
        let a = sin(dLat / 2) * sin(dLat / 2) +
        cos(lat1Rad) * cos(lat2Rad) *
        sin(dLon / 2) * sin(dLon / 2)
        let c = 2 * atan2(sqrt(a), sqrt(1 - a))
        let distance = radius * c
        
        return distance
    }
    
    func isOnPosition(collectible: Collectible) -> Bool {
        let attr = collectible.relatedAttraction
        
        return haversineDistance(lat1: self.currentLocation?.latitude ?? 0.0, lon1: self.currentLocation?.longitude ?? 0.0, lat2: attr.latitude, lon2: attr.longitude) <= attr.radius
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
    func locationManager(_: CLLocationManager, didUpdateLocations locations: [CLLocation]){
        guard let location = locations.first else { return }
        currentLocation = location.coordinate
        print("[Update location at - \(Date())] with - lat: \(currentLocation!.latitude), lng: \(currentLocation!.longitude)")
        
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
