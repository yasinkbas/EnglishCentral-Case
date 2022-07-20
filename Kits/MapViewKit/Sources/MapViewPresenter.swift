//
//  MapViewPresenter.swift
//  MapViewKit
//
//  Created by Yasin Akbas on 12.07.2022.
//  Copyright © 2022 com.yasinkbas.MapViewKit. All rights reserved.
//

import MapKit

public protocol MapViewPresenterInterface: AnyObject {
    var currentLocation: CLLocationCoordinate2D? { get }
    
    func load()
    func centerUserCurrentLocation()
}

extension MapViewPresenter {
    enum Constant {
        static let latitudinalMeters: Double = 2000
        static let longitudinalMeters: Double = 2000
    }
}

public class MapViewPresenter {
    private weak var view: MapViewInterface?
    private let locationManager: LocationManagerInterface
    private var isFirstLoad: Bool = true
    private var userCurrentLocation: CLLocationCoordinate2D?

    public init(view: MapViewInterface, locationManager: LocationManagerInterface = LocationManager()) {
        self.view = view
        self.locationManager = locationManager
    }
}

// MARK: - MapViewPresenterInterface
extension MapViewPresenter: MapViewPresenterInterface {
    public var currentLocation: CLLocationCoordinate2D? { userCurrentLocation }
    
    public func load() {
        view?.prepareUI()
        locationManager.configure(with: self)
        locationManager.start()
    }
    
    public func centerUserCurrentLocation() {
        guard let userCurrentLocation else { return }
        let region = MKCoordinateRegion(center: userCurrentLocation,
                                        latitudinalMeters: Constant.latitudinalMeters,
                                        longitudinalMeters: Constant.longitudinalMeters)
        view?.centerUserLocation(region: region)
    }
}

// MARK: - LocationManagerDelegate
extension MapViewPresenter: LocationManagerDelegate {
    public func locationManager(_ center: CLLocationCoordinate2D?, error: LocationManager.LocationManagerError?) {
        if let error {
            view?.showAlert(message: error.description)
        }
        
        guard let center else { return }
        userCurrentLocation = center
        if isFirstLoad {
            isFirstLoad = false
            centerUserCurrentLocation()
        }
    }
}
