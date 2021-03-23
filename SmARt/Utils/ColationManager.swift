//
//  ColationManager.swift
//  SmARt
//
//  Created by MacBook on 25.02.21.
//

import Foundation
import MapKit
import CoreLocation
import Combine

class LocationManager: NSObject, CLLocationManagerDelegate {
    private let locationManager = CLLocationManager()
    private var locationInitialized = false
    
    var onLocationUpdated = PassthroughSubject<CLLocationCoordinate2D, Never>()
    
    static var shared = LocationManager()
        
    override init() {
        super.init()
        
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = manager.location?.coordinate else { return }
        onLocationUpdated.send(location)
    }
}

