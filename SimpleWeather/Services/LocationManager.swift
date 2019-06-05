//
//  LocationManager.swift
//  SimpleWeather
//
//  Created by Matt Sanford on 6/5/19.
//  Copyright © 2019 Matt Sanford. All rights reserved.
//

import CoreLocation

class LocationManager: NSObject, CLLocationManagerDelegate {
    
    let manager: CLLocationManager = CLLocationManager()
    
    var mostRecentLocation: CLLocation? {
        get {
            manager.location
        }
    }
    
    override init() {
        super.init()
        
        manager.delegate = self
    }
    
    func getInfo(_ completion: @escaping (String, String) -> Void) {
        guard let mostRecent = mostRecentLocation else { return }
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(mostRecent) { (placemarks, error) in
            if let error = error {
                print(error)
                completion("nil", "nil")
                return
            }
            
            if let first = placemarks?.first,
                let zip = first.postalCode,
                let city = first.locality {
                completion(city, zip)
            } else {
                completion("nil", "nil")
            }
            
        }
    }
    
    func requestAuthorization() {
        manager.desiredAccuracy = kCLLocationAccuracyKilometer
        manager.requestWhenInUseAuthorization()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Womp - \(error)")
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let mostRecent = locations.last else { return }
        print(mostRecent)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedWhenInUse:
            manager.startUpdatingLocation()
        case .denied:
            print("Location Denied")
        default:
            print("wat")
        }
    }
}
