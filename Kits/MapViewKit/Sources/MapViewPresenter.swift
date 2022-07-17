//
//  MapViewPresenter.swift
//  MapViewKit
//
//  Created by Yasin Akbas on 12.07.2022.
//  Copyright © 2022 com.yasinkbas.MapViewKit. All rights reserved.
//

import MapKit

public protocol MapViewPresenterInterface: AnyObject {
    func load()
}

public class MapViewPresenter {
    private weak var view: MapViewViewInterface?
    private let locationManager: LocationManagerInterface
    private var isFirstLoad: Bool = true
    private var userCurrentLocation: CLLocationCoordinate2D?

    public init(view: MapViewViewInterface,
                locationManager: LocationManagerInterface = LocationManager()) {
        self.view = view
        self.locationManager = locationManager
    }
    
    private func handleLocationError(error: LocationManager.Error?) {
        
    }
    
    private func centerUserCurrentLocation() {
        guard let userCurrentLocation else { return }
        let region = MKCoordinateRegion(center: userCurrentLocation, latitudinalMeters: 1000, longitudinalMeters: 1000)
        view?.centerUserLocation(region: region)
    }
}

// MARK: - MapViewPresenterInterface
extension MapViewPresenter: MapViewPresenterInterface {
    public func load() {
        view?.prepareUI()
        locationManager.configure(with: self)
        locationManager.start()
        
        
    }
}

// MARK: - LocationManagerDelegate
extension MapViewPresenter: LocationManagerDelegate {
    public func locationManager(_ center: CLLocationCoordinate2D?, error: LocationManager.Error?) {
        if let error {
            handleLocationError(error: error)
        }
        
        guard let center else { return }
        userCurrentLocation = center
        if isFirstLoad {
            isFirstLoad = false
            centerUserCurrentLocation()
        }
    }
}
