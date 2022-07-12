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

    public init(view: MapViewViewInterface,
                locationManager: LocationManagerInterface = LocationManager()) {
        self.view = view
        self.locationManager = locationManager
    }
    
    private func handleLocationError(error: LocationManager.Error?) {
        
    }
}

// MARK: - MapViewPresenterInterface
extension MapViewPresenter: MapViewPresenterInterface {
    public func load() {
        view?.prepareUI()
        locationManager.setUp(with: self)
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
        let region = MKCoordinateRegion(center: center, latitudinalMeters: 1000, longitudinalMeters: 1000)
        view?.centerUserLocation(region: region)
    }
}
