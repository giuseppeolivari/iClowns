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
    
    func isWithinRange(x1: Double, y1: Double, x2: Double, y2: Double, radius: Double) -> Bool {
        let distance = sqrt(pow(x2 - x1, 2) + pow(y2 - y1, 2))
        return distance <= radius
    }
    
    func isOnPosition(collectible: Collectible) -> Bool {
        Task {
            if CLLocationManager.locationServicesEnabled() {
                self.manager.desiredAccuracy = kCLLocationAccuracyBest
                self.manager.startUpdatingLocation()
            }
            
            let attr = collectible.relatedAttraction
            return isWithinRange(x1: self.currentLocation?.longitude ?? 0.0, y1: attr.latitude, x2: self.currentLocation?.latitude ?? 0.0, y2: attr.latitude, radius: attr.radius)
        }
        return false
    }
    
}
