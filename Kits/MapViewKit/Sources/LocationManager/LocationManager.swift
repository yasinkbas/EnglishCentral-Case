//
//  LocationManager.swift
//  MapViewKit
//
//  Created by Yasin Akbas on 12.07.2022.
//  Copyright © 2022 com.yasinkbas.MapViewKit. All rights reserved.
//

import Foundation
import CoreLocation

public protocol LocationManagerInterface: AnyObject {
    func start()
}

public class LocationManager: NSObject {
    private var clLocationManager = CLLocationManager()
    
    public override init() {
        super.init()
        if CLLocationManager.locationServicesEnabled() {
            clLocationManager.delegate = self
            clLocationManager.desiredAccuracy = kCLLocationAccuracyBest
            handleAuthorizationStatus()
        } else {
            print("Location services are not enabled")
        }
    }
    
    private func handleAuthorizationStatus() {
        switch clLocationManager.authorizationStatus {
        case .notDetermined:
            clLocationManager.requestWhenInUseAuthorization()
        case .restricted:
            break // Show alert
        case .denied:
            break // Show alert
        case .authorizedAlways:
            //
            break
        case .authorizedWhenInUse:
            //
            break
        @unknown default:
            break
        }
    }
}

// MARK: - LocationManagerInterface
extension LocationManager: LocationManagerInterface {
    public func start() {
        clLocationManager.startUpdatingLocation()
    }
}

// MARK: - CLLocationManagerDelegate
extension LocationManager: CLLocationManagerDelegate {
    
}
