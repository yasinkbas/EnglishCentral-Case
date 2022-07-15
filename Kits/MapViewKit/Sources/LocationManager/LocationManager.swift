//
//  LocationManager.swift
//  MapViewKit
//
//  Created by Yasin Akbas on 12.07.2022.
//  Copyright © 2022 com.yasinkbas.MapViewKit. All rights reserved.
//

import Foundation
import CoreLocation

public protocol LocationManagerDelegate: AnyObject {
    func locationManager(_ center: CLLocationCoordinate2D?, error: LocationManager.Error?)
}

public protocol LocationManagerInterface: AnyObject {
    func start()
    func configure(with delegate: LocationManagerDelegate)
}

extension LocationManager {
    public enum Error {
        case locationServicesNotEnabled
        case locationNotObtained
    }
}

public class LocationManager: NSObject {
    private weak var delegate: LocationManagerDelegate?
    private var clLocationManager = CLLocationManager()
    
    private func handleAuthorizationStatus(manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
        case .restricted, .denied:
            break // Show alert
        case .authorizedAlways, .authorizedWhenInUse:
            if let center = manager.location?.coordinate {
                delegate?.locationManager(center, error: nil)
            } else {
                delegate?.locationManager(nil, error: .locationNotObtained)
            }
        @unknown default:
            break
        }
    }
    
    public func configure(with delegate: LocationManagerDelegate) {
        self.delegate = delegate
        if CLLocationManager.locationServicesEnabled() {
            clLocationManager.delegate = self
            clLocationManager.desiredAccuracy = kCLLocationAccuracyBest
            handleAuthorizationStatus(manager: clLocationManager)
        } else {
            delegate.locationManager(nil, error: .locationServicesNotEnabled)
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
    public func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        handleAuthorizationStatus(manager: manager)
    }
    
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            delegate?.locationManager(location.coordinate, error: nil)
        }
    }
}
