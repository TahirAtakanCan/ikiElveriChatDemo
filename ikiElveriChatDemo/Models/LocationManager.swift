//
//  LocationManager.swift
//  ikiElveriChatDemo
//
//  Created by Tahir Atakan Can on 21.06.2024.
//

import Foundation
import CoreLocation

class LocationManager: NSObject, CLLocationManagerDelegate {
    
    static let shared = LocationManager()
    
    var locationManager: CLLocationManager?
    var currentLocation: CLLocationCoordinate2D?
    
    private override init() {
        super.init()
        requestLocationAccess()
    }
    
    func requestLocationAccess() {
        
        if locationManager == nil {
            locationManager = CLLocationManager()
            locationManager!.delegate = self
            locationManager!.desiredAccuracy = kCLLocationAccuracyBest
            locationManager!.requestWhenInUseAuthorization()
        }
    }
    
    
    func startUpdating() {
        
        locationManager!.startUpdatingLocation()
        
    }
    
    func stopUpdating() {
        
        if locationManager != nil {
            locationManager!.stopUpdatingLocation()
        }
        
    }
    
    //MARK: - Delegate
    func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
        print("Failed to get location")
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        currentLocation = locations.last!.coordinate
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        
        if manager.authorizationStatus == .notDetermined {
            self.locationManager?.requestWhenInUseAuthorization()
        }
    }
    
}
