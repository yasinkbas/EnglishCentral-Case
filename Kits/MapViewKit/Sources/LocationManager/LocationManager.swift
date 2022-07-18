//
//  LocationManager.swift
//  MapViewKit
//
//  Created by Yasin Akbas on 12.07.2022.
//  Copyright © 2022 com.yasinkbas.MapViewKit. All rights reserved.
//

import Foundation
import CoreLocation
import MapKit

public protocol LocationManagerDelegate: AnyObject {
    func locationManager(_ center: CLLocationCoordinate2D?, error: LocationManager.LocationManagerError?)
}

public protocol LocationManagerInterface: AnyObject {
    func start()
    func configure(with delegate: LocationManagerDelegate)
    func getDistance(latitude: Double, longitude: Double) async throws -> Int
}

extension LocationManager {
    public enum LocationManagerError: Error {
        case locationServicesNotEnabled
        case locationNotObtained
        case routeNotCreated
        
        public var description: String {
            switch self {
            case .locationServicesNotEnabled:
                return "Location services are not available. Please try to enable location services on settings."
            case .locationNotObtained:
                return "Your current location could not obtained. Please try again later."
            default:
                return ""
            }
        }
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
            delegate?.locationManager(nil, error: .locationServicesNotEnabled)
        case .authorizedAlways:
            fatalError()
                break
        case .authorizedWhenInUse:
            if let center = manager.location?.coordinate {
                delegate?.locationManager(center, error: nil)
            } else {
                delegate?.locationManager(nil, error: .locationNotObtained)
            }
        @unknown default:
            break
        }
    }
    
    private func calculateDistancefrom(sourceLocation: MKMapItem, destinationLocation: MKMapItem) async -> TimeInterval{
        
        let request: MKDirections.Request = MKDirections.Request()
        
        request.source = sourceLocation
        request.destination = destinationLocation
        request.requestsAlternateRoutes = true
        request.transportType = .walking
        
        let directions = MKDirections(request: request)
        return await withCheckedContinuation { continuation in
            directions.calculate { (directions, error) in
                
                if var routeResponse = directions?.routes {
                    routeResponse.sort(by: { $0.expectedTravelTime > $1.expectedTravelTime })
                    let quickestRouteForSegment: MKRoute = routeResponse[0]
                    
                    continuation.resume(returning: quickestRouteForSegment.distance)
                } else {
                    continuation.resume(returning: .zero)
                }
            }
        }
    }
}

// MARK: - LocationManagerInterface
extension LocationManager: LocationManagerInterface {
    public func start() {
        clLocationManager.startUpdatingLocation()
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
    
    public func getDistance(latitude: Double, longitude: Double) async throws -> Int {
        let destinationItem =  MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2DMake(latitude, longitude)))
        guard let currentLocation = clLocationManager.location else { throw LocationManagerError.locationNotObtained }
        let sourceItem =  MKMapItem(placemark: MKPlacemark(coordinate: currentLocation.coordinate))

        return Int(await calculateDistancefrom(sourceLocation: sourceItem, destinationLocation: destinationItem))
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
